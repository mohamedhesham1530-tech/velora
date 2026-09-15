import '../../domain/entities/address_entity.dart';

class AddressState {
  final AddressEntity? address;
  final List<AddressEntity> addresses;
  final bool isLoading;
  final String? errorMessage;

  const AddressState({
    this.address,
    this.addresses = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AddressState copyWith({
    AddressEntity? address,
    bool clearAddress = false,
    List<AddressEntity>? addresses,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AddressState(
      address: clearAddress ? null : address ?? this.address,
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
