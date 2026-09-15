import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_error_message.dart';

import '../../domain/entities/address_entity.dart';
import '../../domain/repository/address_repository.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository repository;

  AddressCubit(this.repository) : super(const AddressState());

  Future<void> _pendingOperation = Future.value();
  int _sessionVersion = 0;

  Future<T> _enqueue<T>(Future<T> Function() operation) {
    final next = _pendingOperation.then(
      (_) => operation(),
      onError: (_) => operation(),
    );
    _pendingOperation = next.then<void>((_) {}, onError: (_, __) {});
    return next;
  }

  void reset() {
    _sessionVersion++;
    _pendingOperation = Future.value();
    if (!isClosed) emit(const AddressState());
  }

  Future<void> _loadAddressInternal(int version) async {
    if (version != _sessionVersion || isClosed) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final addresses = await repository.getAddresses();
      final address = await repository.getAddress();
      if (version != _sessionVersion || isClosed) return;
      emit(
        state.copyWith(
          addresses: addresses,
          address: address,
          clearAddress: address == null,
          isLoading: false,
          errorMessage: null,
        ),
      );
    } catch (error) {
      if (version != _sessionVersion || isClosed) return;
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: AppErrorMessage.from(error, fallback: 'We could not load your addresses. Please try again.'),
        ),
      );
    }
  }

  Future<void> loadAddress() {
    final version = _sessionVersion;
    return _enqueue(() => _loadAddressInternal(version));
  }

  Future<void> saveAddress(AddressEntity address) {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      try {
        await repository.saveAddress(address);
        await _loadAddressInternal(version);
      } catch (error) {
        if (version != _sessionVersion || isClosed) return;
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: AppErrorMessage.from(error, fallback: 'We could not save your address. Please try again.'),
          ),
        );
        rethrow;
      }
    });
  }

  Future<void> deleteAddress() {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      try {
        await repository.deleteAddress();
        await _loadAddressInternal(version);
      } catch (error) {
        if (version != _sessionVersion || isClosed) return;
        emit(state.copyWith(errorMessage: AppErrorMessage.from(error, fallback: 'We could not update your address. Please try again.')));
        rethrow;
      }
    });
  }

  Future<void> selectAddress(String id) {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      try {
        await repository.selectAddress(id);
        await _loadAddressInternal(version);
      } catch (error) {
        if (version != _sessionVersion || isClosed) return;
        emit(state.copyWith(errorMessage: AppErrorMessage.from(error, fallback: 'We could not update your address. Please try again.')));
        rethrow;
      }
    });
  }

  Future<void> deleteAddressById(String id) {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      try {
        await repository.deleteAddressById(id);
        await _loadAddressInternal(version);
      } catch (error) {
        if (version != _sessionVersion || isClosed) return;
        emit(state.copyWith(errorMessage: AppErrorMessage.from(error, fallback: 'We could not update your address. Please try again.')));
        rethrow;
      }
    });
  }
}
