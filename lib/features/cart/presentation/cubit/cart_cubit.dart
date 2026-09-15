import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_entity.dart';
import '../../domain/repository/cart_repository.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import 'cart_state.dart';
import 'cart_status.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repository;
  final NotificationCubit? notificationCubit;

  CartCubit({required this.repository, this.notificationCubit})
      : super(const CartState());

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
    if (!isClosed) emit(const CartState());
  }

  Future<void> loadCart() {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      if (state.status != CartStatus.loading) {
        emit(state.copyWith(status: CartStatus.loading, errorMessage: null));
      }
      try {
        final items = await repository.getCartItems();
        if (version != _sessionVersion || isClosed) return;
        emit(
          state.copyWith(
            status: CartStatus.success,
            items: items,
            errorMessage: null,
          ),
        );
      } catch (e) {
        if (version != _sessionVersion || isClosed) return;
        emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }

  Future<bool> addToCart(CartEntity item) {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return false;
      try {
        await repository.addToCart(item);
        if (version != _sessionVersion || isClosed) return false;
        final items = await repository.getCartItems();
        if (version != _sessionVersion || isClosed) return false;
        emit(
          state.copyWith(
            status: CartStatus.success,
            items: items,
            errorMessage: null,
          ),
        );
        return true;
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrintStack(stackTrace: s);
        if (version != _sessionVersion || isClosed) return false;
        emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: 'We could not add this product to your cart. Please try again.',
          ),
        );
        return false;
      }
    });
  }

  Future<bool> removeFromCart(int productId) {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return false;
      try {
        await repository.removeFromCart(productId);
        if (version != _sessionVersion || isClosed) return false;
        final items = await repository.getCartItems();
        if (version != _sessionVersion || isClosed) return false;
        emit(state.copyWith(status: CartStatus.success, items: items));
        return true;
      } catch (e) {
        if (version != _sessionVersion || isClosed) return false;
        emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: e.toString(),
          ),
        );
        return false;
      }
    });
  }

  Future<void> updateQuantity(int productId, int quantity) {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      try {
        await repository.updateQuantity(productId, quantity.clamp(1, 999).toInt());
        if (version != _sessionVersion || isClosed) return;
        final items = await repository.getCartItems();
        if (version != _sessionVersion || isClosed) return;
        emit(state.copyWith(status: CartStatus.success, items: items));
      } catch (e) {
        if (version != _sessionVersion || isClosed) return;
        emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }

  Future<void> increaseQuantity(CartEntity item) {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      CartEntity? current;
      for (final candidate in state.items) {
        if (candidate.productId == item.productId) {
          current = candidate;
          break;
        }
      }
      if (current == null) return;

      try {
        await repository.updateQuantity(
          current.productId,
          current.quantity + 1,
        );
        if (version != _sessionVersion || isClosed) return;
        final items = await repository.getCartItems();
        if (version != _sessionVersion || isClosed) return;
        emit(state.copyWith(status: CartStatus.success, items: items));
      } catch (e) {
        if (version != _sessionVersion || isClosed) return;
        emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }

  Future<void> decreaseQuantity(CartEntity item) {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      CartEntity? current;
      for (final candidate in state.items) {
        if (candidate.productId == item.productId) {
          current = candidate;
          break;
        }
      }
      if (current == null) return;

      try {
        if (current.quantity <= 1) {
          await repository.removeFromCart(current.productId);
        } else {
          await repository.updateQuantity(
            current.productId,
            current.quantity - 1,
          );
        }
        if (version != _sessionVersion || isClosed) return;
        final items = await repository.getCartItems();
        if (version != _sessionVersion || isClosed) return;
        emit(state.copyWith(status: CartStatus.success, items: items));
      } catch (e) {
        if (version != _sessionVersion || isClosed) return;
        emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }

  Future<void> clearCart() {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      try {
        await repository.clearCart();
        if (version != _sessionVersion || isClosed) return;
        emit(state.copyWith(status: CartStatus.success, items: const []));
      } catch (e) {
        if (version != _sessionVersion || isClosed) return;
        emit(
          state.copyWith(
            status: CartStatus.failure,
            errorMessage: e.toString(),
          ),
        );
        rethrow;
      }
    });
  }
}
