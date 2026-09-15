import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/firebase_auth_service.dart';
import '../models/address_model.dart';

class AddressLocalDataSource {
  static const String _baseAddressesKey = 'saved_addresses';
  static const String _baseSelectedAddressKey = 'selected_address_id';

  final SharedPreferences sharedPreferences;
  final FirebaseAuthService authService;

  AddressLocalDataSource({
    required this.sharedPreferences,
    required this.authService,
  });

  String? get _addressesKey {
    final uid = authService.currentUser?.uid;
    return uid == null ? null : '${_baseAddressesKey}_$uid';
  }

  String? get _selectedAddressKey {
    final uid = authService.currentUser?.uid;
    return uid == null ? null : '${_baseSelectedAddressKey}_$uid';
  }

  String _requireAddressesKey() {
    final key = _addressesKey;
    if (key == null) {
      throw StateError('No authenticated user is available for address storage.');
    }
    return key;
  }

  String _requireSelectedKey() {
    final key = _selectedAddressKey;
    if (key == null) {
      throw StateError('No authenticated user is available for address storage.');
    }
    return key;
  }

  AddressModel _copyAddress(AddressModel address, {String? id, bool? isDefault}) {
    return AddressModel(
      id: id ?? address.id,
      fullName: address.fullName,
      phone: address.phone,
      alternatePhone: address.alternatePhone,
      country: address.country,
      governorate: address.governorate,
      city: address.city,
      area: address.area,
      street: address.street,
      building: address.building,
      floor: address.floor,
      apartment: address.apartment,
      landmark: address.landmark,
      notes: address.notes,
      latitude: address.latitude,
      longitude: address.longitude,
      isDefault: isDefault ?? address.isDefault,
    );
  }

  Future<void> saveAddress(AddressModel address) async {
    final addressesKey = _requireAddressesKey();
    final selectedKey = _requireSelectedKey();
    final addresses = await _getAddresses(addressesKey);

    final id = address.id.isNotEmpty
        ? address.id
        : DateTime.now().microsecondsSinceEpoch.toString();

    // The first saved address becomes the default automatically. New
    // addresses are otherwise kept non-default until the user explicitly
    // chooses "Make default".
    final model = _copyAddress(
      address,
      id: id,
      isDefault: addresses.isEmpty ? true : address.isDefault,
    );

    if (model.isDefault) {
      for (var i = 0; i < addresses.length; i++) {
        addresses[i] = _copyAddress(addresses[i], isDefault: false);
      }
    }

    final index = addresses.indexWhere((a) => a.id == id);
    if (index >= 0) {
      addresses[index] = model;
    } else {
      addresses.add(model);
    }

    final json = jsonEncode(addresses.map((a) => a.toJson()).toList());
    if (!await sharedPreferences.setString(addressesKey, json)) {
      throw StateError('Unable to save the addresses.');
    }

    if (!await sharedPreferences.setString(selectedKey, id)) {
      throw StateError('Unable to select the saved address.');
    }
  }

  Future<AddressModel?> getAddress() async {
    final addressesKey = _addressesKey;
    final selectedKey = _selectedAddressKey;
    if (addressesKey == null || selectedKey == null) return null;

    final addresses = await _getAddresses(addressesKey);
    if (addresses.isEmpty) return null;

    final selectedId = sharedPreferences.getString(selectedKey);
    if (selectedId != null && selectedId.isNotEmpty) {
      for (final address in addresses) {
        if (address.id == selectedId) return address;
      }
    }

    return addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => addresses.first,
    );
  }

  Future<void> deleteAddress() async {
    final addressesKey = _addressesKey;
    final selectedKey = _selectedAddressKey;
    if (addressesKey == null || selectedKey == null) return;

    final addresses = await _getAddresses(addressesKey);
    if (addresses.isEmpty) return;

    final selectedId = sharedPreferences.getString(selectedKey);
    String? idToDelete = selectedId;
    if (idToDelete == null || idToDelete.isEmpty) {
      idToDelete = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.first,
      ).id;
    }

    await _deleteById(
      addressesKey: addressesKey,
      selectedKey: selectedKey,
      addresses: addresses,
      idToDelete: idToDelete,
    );
  }

  Future<List<AddressModel>> getAddresses() async {
    final key = _addressesKey;
    if (key == null) return [];
    return _getAddresses(key);
  }

  Future<List<AddressModel>> _getAddresses(String key) async {
    final json = sharedPreferences.getString(key);
    if (json == null || json.isEmpty) return [];

    try {
      final decoded = jsonDecode(json);
      if (decoded is! List) {
        await sharedPreferences.remove(key);
        return [];
      }

      final addresses = <AddressModel>[];
      for (final value in decoded.whereType<Map>()) {
        try {
          addresses.add(AddressModel.fromJson(Map<String, dynamic>.from(value)));
        } catch (_) {
          // Preserve valid addresses when one persisted record is malformed.
        }
      }
      return addresses;
    } catch (_) {
      await sharedPreferences.remove(key);
      return [];
    }
  }

  Future<void> selectAddress(String id) async {
    if (id.isEmpty) return;

    final addressesKey = _addressesKey;
    final selectedKey = _selectedAddressKey;
    if (addressesKey == null || selectedKey == null) return;

    final addresses = await _getAddresses(addressesKey);
    if (!addresses.any((address) => address.id == id)) {
      throw StateError('The selected address no longer exists.');
    }

    if (!await sharedPreferences.setString(selectedKey, id)) {
      throw StateError('Unable to select the address.');
    }
  }

  Future<void> deleteAddressById(String id) async {
    if (id.isEmpty) return;

    final addressesKey = _addressesKey;
    final selectedKey = _selectedAddressKey;
    if (addressesKey == null || selectedKey == null) return;

    final addresses = await _getAddresses(addressesKey);
    if (!addresses.any((address) => address.id == id)) return;

    await _deleteById(
      addressesKey: addressesKey,
      selectedKey: selectedKey,
      addresses: addresses,
      idToDelete: id,
    );
  }

  Future<void> _deleteById({
    required String addressesKey,
    required String selectedKey,
    required List<AddressModel> addresses,
    required String idToDelete,
  }) async {
    final remaining = addresses.where((a) => a.id != idToDelete).toList();

    if (!await sharedPreferences.setString(
      addressesKey,
      jsonEncode(remaining.map((a) => a.toJson()).toList()),
    )) {
      throw StateError('Unable to delete the address.');
    }

    if (remaining.isEmpty) {
      await sharedPreferences.remove(selectedKey);
      return;
    }

    final next = remaining.firstWhere(
      (a) => a.isDefault,
      orElse: () => remaining.first,
    );
    if (!await sharedPreferences.setString(selectedKey, next.id)) {
      throw StateError('Unable to select the remaining address.');
    }
  }
}
