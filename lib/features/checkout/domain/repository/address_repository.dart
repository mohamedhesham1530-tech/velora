import '../entities/address_entity.dart';

abstract class AddressRepository {
  Future<void> saveAddress(AddressEntity address);

  Future<AddressEntity?> getAddress();

  Future<void> deleteAddress();

  Future<List<AddressEntity>> getAddresses();

  Future<void> selectAddress(String id);

  Future<void> deleteAddressById(String id);
}
