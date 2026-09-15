import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final String alternatePhone;

  final String country;
  final String governorate;
  final String city;
  final String area;

  final String street;
  final String building;
  final String floor;
  final String apartment;

  final String landmark;
  final String notes;

  final double latitude;
  final double longitude;

  final bool isDefault;

  const AddressEntity({
    this.id = '',
    required this.fullName,
    required this.phone,
    required this.alternatePhone,
    required this.country,
    required this.governorate,
    required this.city,
    required this.area,
    required this.street,
    required this.building,
    required this.floor,
    required this.apartment,
    required this.landmark,
    required this.notes,
    required this.latitude,
    required this.longitude,
    this.isDefault = true,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    phone,
    alternatePhone,
    country,
    governorate,
    city,
    area,
    street,
    building,
    floor,
    apartment,
    landmark,
    notes,
    latitude,
    longitude,
    isDefault,
  ];
}
