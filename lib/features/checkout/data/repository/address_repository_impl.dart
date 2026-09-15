import '../../domain/entities/address_entity.dart';
import '../../domain/repository/address_repository.dart';
import '../datasource/address_local_datasource.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressLocalDataSource localDataSource;

  AddressRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveAddress(AddressEntity address) async {
    final model = AddressModel(
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
      isDefault: address.isDefault,
      id: address.id,
    );

    await localDataSource.saveAddress(model);
  }

  @override
  Future<AddressEntity?> getAddress() async {
    return await localDataSource.getAddress();
  }

  @override
  Future<void> deleteAddress() async {
    await localDataSource.deleteAddress();
  }

  @override
  Future<List<AddressEntity>> getAddresses() async {
    return await localDataSource.getAddresses();
  }

  @override
  Future<void> selectAddress(String id) async {
    await localDataSource.selectAddress(id);
  }

  @override
  Future<void> deleteAddressById(String id) async {
    await localDataSource.deleteAddressById(id);
  }
}
