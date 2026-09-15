import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> loadNotifications();
  Future<void> saveNotifications(List<NotificationEntity> notifications);
}
