import 'package:flutter/material.dart';

import '../../../../core/utils/responsive.dart';
import 'greeting.dart';
import 'location_widget.dart';
import 'notification_button.dart';
import 'profile_avatar.dart';

class HomeAppBar extends StatelessWidget {
  final String userName;
  final String location;
  final String? imageUrl;

  final VoidCallback? onAvatarTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onLocationTap;
  final bool hasNotification;

  const HomeAppBar({
    super.key,
    required this.userName,
    required this.location,
    this.imageUrl,
    this.onAvatarTap,
    this.onNotificationTap,
    this.onLocationTap,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.hp(.015)),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileAvatar(imageUrl: imageUrl, onTap: onAvatarTap),

            SizedBox(width: context.wp(.035)),

            Greeting(userName: userName),

            SizedBox(width: context.wp(.02)),

            NotificationButton(
              onPressed: onNotificationTap,
              hasNotification: hasNotification,
            ),
          ],
        ),

        SizedBox(height: context.hp(.025)),

        LocationWidget(location: location, onTap: onLocationTap),
      ],
    );
  }
}
