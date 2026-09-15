import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.fullName,
    required super.phone,
    required super.alternatePhone,
    required super.country,
    required super.governorate,
    required super.city,
    required super.area,
    required super.street,
    required super.building,
    required super.floor,
    required super.apartment,
    required super.landmark,
    required super.notes,
    required super.latitude,
    required super.longitude,
    super.isDefault,
    super.id,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    String stringValue(String key) => json[key] is String ? json[key] as String : '';
    double numberValue(String key) => (json[key] as num?)?.toDouble() ?? 0;
    return AddressModel(
      id: stringValue('id'),
      fullName: stringValue('fullName'),
      phone: stringValue('phone'),
      alternatePhone: stringValue('alternatePhone'),
      country: stringValue('country'),
      governorate: stringValue('governorate'),
      city: stringValue('city'),
      area: stringValue('area'),
      street: stringValue('street'),
      building: stringValue('building'),
      floor: stringValue('floor'),
      apartment: stringValue('apartment'),
      landmark: stringValue('landmark'),
      notes: stringValue('notes'),
      latitude: numberValue('latitude'),
      longitude: numberValue('longitude'),
      isDefault: json['isDefault'] is bool ? json['isDefault'] as bool : true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'alternatePhone': alternatePhone,
      'country': country,
      'governorate': governorate,
      'city': city,
      'area': area,
      'street': street,
      'building': building,
      'floor': floor,
      'apartment': apartment,
      'landmark': landmark,
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }
}
