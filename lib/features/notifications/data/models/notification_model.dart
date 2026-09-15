import '../../domain/entities/notification_entity.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String iconName;
  final String createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.iconName,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      iconName: entity.iconName,
      createdAt: entity.createdAt.toUtc().toIso8601String(),
      isRead: entity.isRead,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      iconName: iconName,
      createdAt: DateTime.parse(createdAt).toLocal(),
      isRead: isRead,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      iconName: json['iconName'] as String,
      createdAt: json['createdAt'] as String,
      isRead: json['isRead'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'iconName': iconName,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }
}
