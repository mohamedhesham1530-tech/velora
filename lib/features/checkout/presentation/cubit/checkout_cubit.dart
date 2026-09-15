import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/address_entity.dart';
import '../../domain/repository/address_repository.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository repository;

  AddressCubit(this.repository) : super(const AddressState());

  Future<void> loadAddress() async {
    emit(state.copyWith(isLoading: true));

    final address = await repository.getAddress();

    emit(state.copyWith(address: address, isLoading: false));
  }

  Future<void> saveAddress(AddressEntity address) async {
    await repository.saveAddress(address);

    emit(state.copyWith(address: address));
  }

  Future<void> deleteAddress() async {
    await repository.deleteAddress();

    emit(const AddressState());
  }
}
