import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit({required this.repository})
      : super(const NotificationState());

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
    if (!isClosed) emit(const NotificationState());
  }

  Future<void> loadNotifications() {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      emit(state.copyWith(isLoading: true));
      try {
        final notifications = await repository.loadNotifications();
        if (version != _sessionVersion || isClosed) return;
        emit(
          state.copyWith(
            notifications: notifications,
            isLoading: false,
          ),
        );
      } catch (error, stackTrace) {
        debugPrint('Unable to load notifications: $error');
        debugPrintStack(stackTrace: stackTrace);
        if (version != _sessionVersion || isClosed) return;
        emit(state.copyWith(isLoading: false));
      }
    });
  }

  Future<void> addNotification({
    required String title,
    required String body,
    required String iconName,
    DateTime? createdAt,
  }) {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      final notification = NotificationEntity(
        id: '${DateTime.now().microsecondsSinceEpoch}',
        title: title,
        body: body,
        iconName: iconName,
        createdAt: createdAt ?? DateTime.now(),
      );
      await _saveInternal([notification, ...state.notifications], version);
    });
  }

  Future<void> markAsRead(String id) {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      final notifications = state.notifications.map((notification) {
        if (notification.id == id) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();
      await _saveInternal(notifications, version);
    });
  }

  Future<void> markAllAsRead() {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      final notifications = state.notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();
      await _saveInternal(notifications, version);
    });
  }

  Future<void> deleteNotification(String id) {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      final notifications = state.notifications
          .where((notification) => notification.id != id)
          .toList();
      await _saveInternal(notifications, version);
    });
  }

  Future<void> clearAll() {
    final version = _sessionVersion;
    return _enqueue(() async {
      if (version != _sessionVersion || isClosed) return;
      await _saveInternal(const [], version);
    });
  }

  Future<void> _saveInternal(
    List<NotificationEntity> notifications,
    int version,
  ) async {
    try {
      await repository.saveNotifications(notifications);
      if (version != _sessionVersion || isClosed) return;
      emit(state.copyWith(notifications: notifications));
    } catch (error, stackTrace) {
      debugPrint('Unable to save notifications: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  int get unreadCount =>
      state.notifications.where((item) => !item.isRead).length;

  IconData iconFromName(String iconName) {
    switch (iconName) {
      case 'shopping_cart':
        return Icons.shopping_cart_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'receipt':
        return Icons.receipt_long_rounded;
      case 'person':
        return Icons.person_rounded;
      case 'photo_camera':
        return Icons.photo_camera_rounded;
      case 'language':
        return Icons.language_rounded;
      case 'dark_mode':
        return Icons.dark_mode_rounded;
      case 'notifications':
      default:
        return Icons.notifications_rounded;
    }
  }
}
