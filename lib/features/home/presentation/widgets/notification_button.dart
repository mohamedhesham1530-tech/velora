import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class NotificationButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool hasNotification;

  const NotificationButton({
    super.key,
    this.onPressed,
    this.hasNotification = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = context.responsive(mobile: 54, tablet: 60, desktop: 66);

    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,

            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,

              border: Border.all(
                color: AppColors.primary.withOpacity(.15),
                width: 2,
              ),

              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
              size: size * .45,
            ),
          ),

          if (hasNotification)
            Positioned(
              right: 3,
              top: 3,

              child: Container(
                width: 12,
                height: 12,

                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,

                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn().scale(duration: 500.ms, curve: Curves.easeOutBack);
  }
}
