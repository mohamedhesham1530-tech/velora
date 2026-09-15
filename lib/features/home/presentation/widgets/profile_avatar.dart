import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onTap;

  const ProfileAvatar({super.key, this.imageUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = context.responsive(mobile: 54, tablet: 60, desktop: 66);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
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
        child: ClipOval(
          child: imageUrl == null || imageUrl!.isEmpty
              ? Icon(Icons.person, size: size * .55, color: AppColors.primary)
              : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.person,
                    size: size * .55,
                    color: AppColors.primary,
                  ),
                ),
        ),
      ),
    ).animate().fadeIn().scale(duration: 500.ms, curve: Curves.easeOutBack);
  }
}
