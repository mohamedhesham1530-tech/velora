import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_error_message.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/repository/orders_repository.dart';

import '../../../notifications/presentation/cubit/notification_cubit.dart';

import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository repository;
  final NotificationCubit? notificationCubit;

  OrdersCubit({required this.repository, this.notificationCubit})
    : super(const OrdersState());

  /// Serializes order operations to prevent concurrent local-storage
  /// mutations from overwriting each other.
  Future<void> _pendingOperation = Future<void>.value();

  /// Identifies the currently active authentication/session version.
  ///
  /// When the user logs out or changes, the version is incremented.
  /// Any old asynchronous operation becomes invalid and is ignored.
  int _sessionVersion = 0;

  /// Prevents two order operations from mutating the repository
  /// concurrently.
  Future<T> _enqueue<T>(Future<T> Function() operation) {
    final Future<T> next = _pendingOperation.then<T>(
      (_) => operation(),
      onError: (_, __) => operation(),
    );

    // Keep the queue alive even when an individual operation fails.
    _pendingOperation = next.then<void>((_) {}, onError: (_, __) {});

    return next;
  }

  /// Clears all in-memory order state and invalidates previously started
  /// asynchronous operations.
  ///
  /// This should be called when:
  /// - the user logs out
  /// - the authenticated user changes
  /// - the session needs to be reset
  void reset() {
    _sessionVersion++;

    // Old queued operations must not be allowed to affect the new session.
    _pendingOperation = Future<void>.value();

    if (isClosed) {
      return;
    }

    emit(const OrdersState());
  }

  /// Loads the current user's orders.
  Future<void> loadOrders() {
    final int version = _sessionVersion;

    return _enqueue<void>(() async {
      if (version != _sessionVersion || isClosed) {
        return;
      }

      emit(state.copyWith(isLoading: true, errorMessage: null));

      try {
        final orders = await repository.getOrders();

        if (version != _sessionVersion || isClosed) {
          return;
        }

        emit(
          state.copyWith(orders: orders, isLoading: false, errorMessage: null),
        );
      } catch (error) {
        if (version != _sessionVersion || isClosed) {
          return;
        }

        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: AppErrorMessage.from(
              error,
              fallback: 'We could not load your orders. Please try again.',
            ),
          ),
        );
      }
    });
  }

  /// Adds a new order and refreshes the order list.
  ///
  /// The order itself is the primary operation.
  /// Notification creation is intentionally secondary: a notification
  /// failure must never make a successfully-created order look like a
  /// failed order.
  Future<void> addOrder(OrderEntity order) {
    final int version = _sessionVersion;

    return _enqueue<void>(() async {
      if (version != _sessionVersion || isClosed) {
        return;
      }

      try {
        await repository.addOrder(order);

        if (version != _sessionVersion || isClosed) {
          return;
        }

        final orders = await repository.getOrders();

        if (version != _sessionVersion || isClosed) {
          return;
        }

        emit(
          state.copyWith(orders: orders, isLoading: false, errorMessage: null),
        );

        // Notification is a secondary operation.
        // Failure here must not invalidate the successful order.
        if (notificationCubit != null &&
            version == _sessionVersion &&
            !isClosed) {
          try {
            await notificationCubit!.addNotification(
              title: 'Order Placed',
              body: 'Your order was placed successfully.',
              iconName: 'receipt',
            );
          } catch (notificationError, notificationStack) {
            if (kDebugMode) {
              debugPrint('Order notification failed: $notificationError');
              debugPrintStack(stackTrace: notificationStack);
            }
          }
        }
      } catch (error, stackTrace) {
        if (version != _sessionVersion || isClosed) {
          return;
        }

        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: AppErrorMessage.from(
              error,
              fallback:
                  'We could not complete this order action. Please try again.',
            ),
          ),
        );

        // Do NOT rethrow here.
        //
        // The error has already been converted into the Cubit's state.
        // Rethrowing could create an unhandled Future exception if the UI
        // calls addOrder() without awaiting/catching the Future.
        if (kDebugMode) {
          debugPrint('OrdersCubit.addOrder failed: $error');
          debugPrintStack(stackTrace: stackTrace);
        }
      }
    });
  }

  /// Clears all orders for the current user.
  Future<void> clearOrders() {
    final int version = _sessionVersion;

    return _enqueue<void>(() async {
      if (version != _sessionVersion || isClosed) {
        return;
      }

      try {
        await repository.clearOrders();

        if (version != _sessionVersion || isClosed) {
          return;
        }

        emit(const OrdersState());

        // Notification is secondary and must not affect the successful
        // clear operation.
        if (notificationCubit != null &&
            version == _sessionVersion &&
            !isClosed) {
          try {
            await notificationCubit!.addNotification(
              title: 'Orders Cleared',
              body: 'Your order history was cleared successfully.',
              iconName: 'receipt',
            );
          } catch (notificationError, notificationStack) {
            if (kDebugMode) {
              debugPrint(
                'Order clear notification failed: '
                '$notificationError',
              );
              debugPrintStack(stackTrace: notificationStack);
            }
          }
        }
      } catch (error, stackTrace) {
        if (version != _sessionVersion || isClosed) {
          return;
        }

        emit(
          state.copyWith(
            errorMessage: AppErrorMessage.from(
              error,
              fallback:
                  'We could not complete this order action. Please try again.',
            ),
          ),
        );

        if (kDebugMode) {
          debugPrint('OrdersCubit.clearOrders failed: $error');
          debugPrintStack(stackTrace: stackTrace);
        }
      }
    });
  }
}
