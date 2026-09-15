import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/responsive.dart';

class Greeting extends StatelessWidget {
  final String userName;

  const Greeting({super.key, required this.userName});

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning 👋";
    }

    if (hour < 17) {
      return "Good Afternoon ☀️";
    }

    return "Good Evening 🌙";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey700,
              fontWeight: FontWeight.w600,
              fontSize: context.responsive(mobile: 15, tablet: 16, desktop: 17),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: context.responsive(mobile: 22, tablet: 24, desktop: 26),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -.15, duration: 500.ms);
  }
}
