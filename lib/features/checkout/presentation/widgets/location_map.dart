import 'dart:async';
import 'dart:ui';

import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/services/location/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

typedef LocationChangedCallback =
    void Function({
      required double latitude,
      required double longitude,
      required String country,
      required String governorate,
      required String city,
      required String area,
      required String street,
    });

class LocationMap extends StatefulWidget {
  const LocationMap({
    super.key,
    required this.onLocationChanged,
    this.initialLatitude,
    this.initialLongitude,
    this.enabled = true,
  });

  final LocationChangedCallback onLocationChanged;
  final double? initialLatitude;
  final double? initialLongitude;
  final bool enabled;

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  final LocationService _locationService = sl<LocationService>();
  final MapController _mapController = MapController();

  // Cairo is only a safe visual starting point. It is NOT treated as a
  // selected delivery location until the user chooses a point.
  static const LatLng _defaultLocation = LatLng(30.0444, 31.2357);

  late LatLng _selectedLocation;

  bool _mapReady = false;
  bool _hasSelectedLocation = false;
  bool _gettingCurrentLocation = false;
  bool _gettingAddress = false;

  int _requestId = 0;
  bool _geocodingInProgress = false;
  LatLng? _pendingGeocodeLocation;

  String? _locationMessage;
  bool _locationMessageIsError = false;
  bool _locationPermissionPermanentlyDenied = false;

  @override
  void initState() {
    super.initState();

    final initial = _validInitialLocation();
    if (initial != null) {
      _selectedLocation = initial;
      _hasSelectedLocation = true;
    } else {
      _selectedLocation = _defaultLocation;
    }
  }

  LatLng? _validInitialLocation() {
    final latitude = widget.initialLatitude;
    final longitude = widget.initialLongitude;

    if (latitude == null ||
        longitude == null ||
        !latitude.isFinite ||
        !longitude.isFinite ||
        latitude.abs() > 90 ||
        longitude.abs() > 180 ||
        (latitude == 0 && longitude == 0)) {
      return null;
    }

    return LatLng(latitude, longitude);
  }

  Future<void> _loadCurrentLocation() async {
    if (!widget.enabled || _gettingCurrentLocation || !mounted) return;

    setState(() {
      _gettingCurrentLocation = true;
      _locationMessage = null;
      _locationMessageIsError = false;
      _locationPermissionPermanentlyDenied = false;
    });

    try {
      final serviceEnabled = await _locationService.isLocationEnabled();

      if (!serviceEnabled) {
        _showLocationMessage(
          'Location services are turned off. Turn them on to use your current location, or choose a point manually on the map.',
          isError: true,
          permanentPermission: false,
        );
        return;
      }

      var permission = await _locationService.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await _locationService.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationMessage(
          'Location permission is disabled for Velora. You can enable it from Settings or choose your delivery location manually.',
          isError: true,
          permanentPermission: true,
        );
        return;
      }

      if (permission == LocationPermission.denied) {
        _showLocationMessage(
          'Location permission was not granted. You can still choose any delivery location manually on the map.',
          isError: true,
        );
        return;
      }

      Position? position;

      try {
        position = await _locationService
            .getCurrentLocation()
            .timeout(const Duration(seconds: 12));
      } on TimeoutException {
        position = null;
      }

      // A last-known position is only a fallback when a fresh fix is not
      // available. It still gives the user a useful starting point, while
      // the user can always move the pin manually.
      position ??= await _locationService.getLastKnownLocation();

      if (!mounted) return;

      if (position == null ||
          !position.latitude.isFinite ||
          !position.longitude.isFinite ||
          position.latitude.abs() > 90 ||
          position.longitude.abs() > 180) {
        _showLocationMessage(
          'We could not get your current location. Please try again or choose the delivery location manually on the map.',
          isError: true,
        );
        return;
      }

      final location = LatLng(position.latitude, position.longitude);

      // IMPORTANT: notify the form immediately. Coordinates remain valid even
      // if reverse geocoding later fails.
      _selectLocation(location, notifyParent: true);

      // Reverse geocoding is best-effort. It must never invalidate the
      // selected coordinates or prevent the user from saving manually.
      await _reverseGeocode(location);
    } on TimeoutException {
      if (!mounted) return;
      _showLocationMessage(
        'Location lookup took too long. Please try again or choose a point manually on the map.',
        isError: true,
      );
    } catch (error, stackTrace) {
      debugPrint('Location error: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      _showLocationMessage(
        'We could not access your current location. You can still choose any delivery location on the map.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _gettingCurrentLocation = false;
        });
      }
    }
  }

  void _showLocationMessage(
    String message, {
    bool isError = false,
    bool permanentPermission = false,
  }) {
    if (!mounted) return;

    setState(() {
      _locationMessage = message;
      _locationMessageIsError = isError;
      _locationPermissionPermanentlyDenied = permanentPermission;
    });
  }

  void _clearLocationMessage() {
    if (!mounted) return;

    if (_locationMessage != null) {
      setState(() {
        _locationMessage = null;
        _locationMessageIsError = false;
        _locationPermissionPermanentlyDenied = false;
      });
    }
  }

  void _selectLocation(
    LatLng location, {
    bool notifyParent = true,
  }) {
    if (!mounted) return;

    setState(() {
      _selectedLocation = location;
      _hasSelectedLocation = true;
      _locationMessage = null;
      _locationMessageIsError = false;
      _locationPermissionPermanentlyDenied = false;
    });

    if (_mapReady) {
      try {
        _mapController.move(location, 17);
      } catch (error, stackTrace) {
        debugPrint('Map move error: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    if (notifyParent) {
      // Send coordinates immediately. Address text is intentionally empty
      // here; reverse geocoding will send the detected fields afterward.
      widget.onLocationChanged(
        latitude: location.latitude,
        longitude: location.longitude,
        country: '',
        governorate: '',
        city: '',
        area: '',
        street: '',
      );
    }
  }

  Future<void> _onMapTapped(LatLng location) async {
    if (!widget.enabled || !mounted) return;

    _selectLocation(location, notifyParent: true);
    await _reverseGeocode(location);
  }

  Future<void> _reverseGeocode(LatLng location) async {
    if (!mounted) return;

    _pendingGeocodeLocation = location;

    if (_geocodingInProgress) {
      return;
    }

    _geocodingInProgress = true;

    try {
      while (mounted && _pendingGeocodeLocation != null) {
        final target = _pendingGeocodeLocation;
        _pendingGeocodeLocation = null;

        if (target == null) break;

        final request = ++_requestId;

        setState(() {
          _gettingAddress = true;
          _locationMessage = null;
          _locationMessageIsError = false;
        });

        try {
          final placemarks = await placemarkFromCoordinates(
            target.latitude,
            target.longitude,
          ).timeout(const Duration(seconds: 10));

          if (!mounted || request != _requestId) {
            continue;
          }

          if (placemarks.isEmpty) {
            _showLocationMessage(
              'Location selected. The address could not be detected automatically, so please complete the address fields manually.',
            );
            continue;
          }

          final place = placemarks.first;

          final country = (place.country ?? '').trim();
          final governorate = (place.administrativeArea ?? '').trim();
          final city =
              (place.locality ?? place.subAdministrativeArea ?? '').trim();
          final area =
              (place.subLocality ?? place.subAdministrativeArea ?? '').trim();
          final street = (place.street ?? '').trim();

          widget.onLocationChanged(
            latitude: target.latitude,
            longitude: target.longitude,
            country: country,
            governorate: governorate,
            city: city,
            area: area,
            street: street,
          );

          if (country.isEmpty &&
              governorate.isEmpty &&
              city.isEmpty &&
              area.isEmpty &&
              street.isEmpty) {
            _showLocationMessage(
              'Location selected. Please review and complete the address details.',
            );
          } else {
            _clearLocationMessage();
          }
        } on TimeoutException {
          if (mounted && request == _requestId) {
            _showLocationMessage(
              'Location selected. Address detection took too long, but your map location is saved. You can complete the fields manually.',
            );
          }
        } catch (error, stackTrace) {
          debugPrint('Reverse geocoding error: $error');
          debugPrintStack(stackTrace: stackTrace);

          if (mounted && request == _requestId) {
            _showLocationMessage(
              'Location selected. We could not detect the address automatically, so please review the fields manually.',
            );
          }
        } finally {
          if (mounted && request == _requestId) {
            setState(() {
              _gettingAddress = false;
            });
          }
        }
      }
    } finally {
      _geocodingInProgress = false;

      if (mounted) {
        setState(() {
          _gettingAddress = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _requestId++;
    _pendingGeocodeLocation = null;

    try {
      _mapController.dispose();
    } catch (_) {
      // MapController disposal should never be allowed to crash the screen.
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primary.withValues(alpha: 0.14),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Choose your delivery point on the map, or use your current location. We will fill the address details automatically when the location service can identify them.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 300,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation,
                    initialZoom: _hasSelectedLocation ? 17 : 12,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                    onMapReady: () {
                      if (!mounted) return;

                      _mapReady = true;

                      if (_hasSelectedLocation) {
                        try {
                          _mapController.move(_selectedLocation, 17);
                        } catch (_) {}
                      }
                    },
                    onTap: (_, point) {
                      unawaited(_onMapTapped(point));
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.e_commerce',
                      maxZoom: 19,
                    ),
                    if (_hasSelectedLocation)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLocation,
                            width: 54,
                            height: 54,
                            child: Icon(
                              Icons.location_pin,
                              color: primary,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                    RichAttributionWidget(
                      attributions: [
                        const TextSourceAttribution(
                          'OpenStreetMap contributors',
                        ),
                      ],
                    ),
                  ],
                ),
                if (_gettingCurrentLocation)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.10),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: colorScheme.surface,
                    elevation: 3,
                    borderRadius: BorderRadius.circular(12),
                    child: IconButton(
                      tooltip: 'Use current location',
                      onPressed: widget.enabled && !_gettingCurrentLocation
                          ? _loadCurrentLocation
                          : null,
                      icon: const Icon(Icons.my_location),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(
              _hasSelectedLocation
                  ? Icons.check_circle_outline
                  : Icons.touch_app_outlined,
              size: 20,
              color: _hasSelectedLocation
                  ? Colors.green
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _hasSelectedLocation
                    ? 'Location selected. Tap another point to move the delivery location.'
                    : 'No location selected. Tap anywhere on the map or use your current location.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
        if (_hasSelectedLocation) ...[
          const SizedBox(height: 10),
          _CoordinatesCard(
            latitude: _selectedLocation.latitude,
            longitude: _selectedLocation.longitude,
          ),
        ],
        if (_gettingAddress) ...[
          const SizedBox(height: 10),
          const LinearProgressIndicator(),
          const SizedBox(height: 6),
          Text(
            'Detecting address details…',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (_locationMessage != null) ...[
          const SizedBox(height: 10),
          _LocationMessageCard(
            message: _locationMessage!,
            isError: _locationMessageIsError,
            showSettings: _locationPermissionPermanentlyDenied,
            onRetry: _locationPermissionPermanentlyDenied
                ? _locationService.openAppSettings
                : _loadCurrentLocation,
          ),
        ],
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: widget.enabled && !_gettingCurrentLocation
                ? _loadCurrentLocation
                : null,
            icon: const Icon(Icons.my_location),
            label: Text(
              _gettingCurrentLocation
                  ? 'Getting current location…'
                  : 'Use Current Location',
            ),
          ),
        ),
      ],
    );
  }
}

class _CoordinatesCard extends StatelessWidget {
  const _CoordinatesCard({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.gps_fixed_rounded,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected coordinates',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  'Latitude: ${latitude.toStringAsFixed(6)}\n'
                  'Longitude: ${longitude.toStringAsFixed(6)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationMessageCard extends StatelessWidget {
  const _LocationMessageCard({
    required this.message,
    required this.isError,
    required this.showSettings,
    required this.onRetry,
  });

  final String message;
  final bool isError;
  final bool showSettings;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isError ? colorScheme.error : colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.info_outline : Icons.check_circle_outline,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          if (isError)
            TextButton(
              onPressed: () => unawaited(onRetry()),
              child: Text(showSettings ? 'Settings' : 'Retry'),
            ),
        ],
      ),
    );
  }
}
