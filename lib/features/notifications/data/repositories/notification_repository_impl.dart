import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/firebase_auth_service.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  static const _baseStorageKey = 'velora_notifications';

  final SharedPreferences preferences;
  final FirebaseAuthService authService;

  NotificationRepositoryImpl({
    required this.preferences,
    required this.authService,
  });

  String? get _storageKey {
    final uid = authService.currentUser?.uid;
    return uid == null ? null : '${_baseStorageKey}_$uid';
  }

  @override
  Future<List<NotificationEntity>> loadNotifications() async {
    final key = _storageKey;
    if (key == null) return const [];

    final rawNotifications = preferences.getStringList(key);
    if (rawNotifications == null || rawNotifications.isEmpty) {
      return const [];
    }

    final notifications = <NotificationEntity>[];
    for (final item in rawNotifications) {
      try {
        final model = NotificationModel.fromJson(
          jsonDecode(item) as Map<String, dynamic>,
        );
        notifications.add(model.toEntity());
      } catch (_) {
        // Ignore one malformed persisted notification instead of failing the list.
      }
    }

    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notifications;
  }

  @override
  Future<void> saveNotifications(
    List<NotificationEntity> notifications,
  ) async {
    final key = _storageKey;
    if (key == null) return;

    final payload = notifications
        .map(
          (notification) =>
              NotificationModel.fromEntity(notification).toJson(),
        )
        .map(jsonEncode)
        .toList();

    if (!await preferences.setStringList(key, payload)) {
      throw StateError('Unable to save notifications.');
    }
  }
}
