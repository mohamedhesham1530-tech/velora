import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_extensions.dart';

class DiscountBadge extends StatelessWidget {
  final String discount;

  const DiscountBadge({super.key, required this.discount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.error,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: context.colors.error.withOpacity(.30),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        discount,
        style: AppTextStyles.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).animate().fadeIn().scale(duration: 450.ms, curve: Curves.easeOutBack);
  }
}
