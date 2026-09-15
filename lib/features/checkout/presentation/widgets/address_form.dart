import 'package:e_commerce/features/checkout/domain/entities/address_entity.dart';
import 'package:e_commerce/features/checkout/presentation/cubit/address_cubit.dart';
import 'package:e_commerce/features/checkout/presentation/widgets/location_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key, this.address});

  final AddressEntity? address;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final alternatePhoneController = TextEditingController();

  final countryController = TextEditingController();
  final governorateController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();

  final streetController = TextEditingController();
  final buildingController = TextEditingController();
  final floorController = TextEditingController();
  final apartmentController = TextEditingController();

  final landmarkController = TextEditingController();
  final notesController = TextEditingController();

  double? latitude;
  double? longitude;
  bool _hasSelectedLocation = false;
  bool _isSaving = false;
  String? _saveError;

  @override
  void initState() {
    super.initState();

    final address = widget.address;

    if (address != null) {
      fullNameController.text = address.fullName;
      phoneController.text = address.phone;
      alternatePhoneController.text = address.alternatePhone;

      countryController.text = address.country;
      governorateController.text = address.governorate;
      cityController.text = address.city;
      areaController.text = address.area;

      streetController.text = address.street;
      buildingController.text = address.building;
      floorController.text = address.floor;
      apartmentController.text = address.apartment;

      landmarkController.text = address.landmark;
      notesController.text = address.notes;

      if (_isValidCoordinates(address.latitude, address.longitude)) {
        latitude = address.latitude;
        longitude = address.longitude;
        _hasSelectedLocation = true;
      }
    }
  }

  bool _isValidCoordinates(double lat, double lng) {
    return lat.isFinite &&
        lng.isFinite &&
        lat.abs() <= 90 &&
        lng.abs() <= 180 &&
        !(lat == 0 && lng == 0);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    alternatePhoneController.dispose();
    countryController.dispose();
    governorateController.dispose();
    cityController.dispose();
    areaController.dispose();
    streetController.dispose();
    buildingController.dispose();
    floorController.dispose();
    apartmentController.dispose();
    landmarkController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (!_hasSelectedLocation ||
        latitude == null ||
        longitude == null ||
        !_isValidCoordinates(latitude!, longitude!)) {
      setState(() {
        _saveError =
            'Please select your delivery location on the map before saving.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    final address = AddressEntity(
      id: widget.address?.id ?? '',
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      alternatePhone: alternatePhoneController.text.trim(),
      country: countryController.text.trim(),
      governorate: governorateController.text.trim(),
      city: cityController.text.trim(),
      area: areaController.text.trim(),
      street: streetController.text.trim(),
      building: buildingController.text.trim(),
      floor: floorController.text.trim(),
      apartment: apartmentController.text.trim(),
      landmark: landmarkController.text.trim(),
      notes: notesController.text.trim(),
      latitude: latitude!,
      longitude: longitude!,
      isDefault: widget.address?.isDefault ?? false,
    );

    try {
      await context.read<AddressCubit>().saveAddress(address);

      if (!mounted) return;

      // The parent screen owns success feedback. Returning true lets it
      // refresh the list and show one consistent, polished message.
      Navigator.of(context).pop(true);
    } catch (error, stackTrace) {
      debugPrint('Save address error: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _saveError = 'We could not save this address. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _onLocationChanged({
    required double latitude,
    required double longitude,
    required String country,
    required String governorate,
    required String city,
    required String area,
    required String street,
  }) {
    if (!mounted) return;

    setState(() {
      this.latitude = latitude;
      this.longitude = longitude;
      _hasSelectedLocation = true;
      _saveError = null;

      if (country.isNotEmpty) countryController.text = country;
      if (governorate.isNotEmpty) governorateController.text = governorate;
      if (city.isNotEmpty) cityController.text = city;
      if (area.isNotEmpty) areaController.text = area;
      if (street.isNotEmpty) streetController.text = street;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          _buildSectionHeader(
            context,
            icon: Icons.person_outline,
            title: 'Contact information',
            subtitle: 'Who should receive this delivery?',
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: fullNameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            validator: _validateName,
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
            ],
            validator: _validatePhone,
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: alternatePhoneController,
            label: 'Alternative Phone (optional)',
            icon: Icons.phone_enabled_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
            ],
            validator: _validateOptionalPhone,
          ),

          const SizedBox(height: 28),

          _buildSectionHeader(
            context,
            icon: Icons.location_on_outlined,
            title: 'Delivery location',
            subtitle:
                'Choose a point on the map. The address fields will be filled automatically when available.',
          ),
          const SizedBox(height: 14),

          LocationMap(
            initialLatitude: widget.address?.latitude,
            initialLongitude: widget.address?.longitude,
            enabled: !_isSaving,
            onLocationChanged: _onLocationChanged,
          ),

          const SizedBox(height: 28),

          _buildSectionHeader(
            context,
            icon: Icons.home_work_outlined,
            title: 'Address details',
            subtitle: 'Review the detected details and correct anything necessary.',
          ),
          const SizedBox(height: 14),

          _buildField(
            controller: countryController,
            label: 'Country',
            icon: Icons.flag_outlined,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: governorateController,
            label: 'Governorate',
            icon: Icons.location_city_outlined,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: cityController,
            label: 'City',
            icon: Icons.location_on_outlined,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: areaController,
            label: 'Area / District',
            icon: Icons.map_outlined,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: streetController,
            label: 'Street',
            icon: Icons.route_outlined,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: buildingController,
            label: 'Building',
            icon: Icons.apartment_outlined,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: floorController,
            label: 'Floor',
            icon: Icons.stairs_outlined,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: apartmentController,
            label: 'Apartment',
            icon: Icons.home_work_outlined,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 28),

          _buildSectionHeader(
            context,
            icon: Icons.more_horiz,
            title: 'Additional details',
            subtitle: 'Optional details that help the courier find you.',
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: landmarkController,
            label: 'Landmark (optional)',
            icon: Icons.place_outlined,
            textInputAction: TextInputAction.next,
            validator: _validateOptional,
          ),
          const SizedBox(height: 14),
          _buildField(
            controller: notesController,
            label: 'Delivery notes (optional)',
            icon: Icons.notes_outlined,
            maxLines: 3,
            minLines: 3,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            validator: _validateOptional,
          ),

          const SizedBox(height: 28),

          if (_saveError != null) ...[
            _buildInlineMessage(
              context,
              message: _saveError!,
              isError: true,
            ),
            const SizedBox(height: 14),
          ],

          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                _isSaving
                    ? 'Saving...'
                    : widget.address == null
                    ? 'Save Address'
                    : 'Update Address',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineMessage(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isError ? colorScheme.error : colorScheme.primary;

    return Container(
      width: double.infinity,
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
            isError
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    int? minLines,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      enabled: !_isSaving,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator ?? _validateRequired,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        labelText: label,
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Full name is required';
    if (text.length < 2) return 'Enter a valid full name';
    return null;
  }

  String? _validatePhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Phone number is required';
    final normalized = text.replaceAll(RegExp(r'[\s-]'), '');
    if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(normalized)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validateOptionalPhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    return _validatePhone(text);
  }

  String? _validateOptional(String? value) => null;
}
