import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';

class BackButtonWidget extends StatelessWidget {
  final bool visible;
  final VoidCallback onPressed;

  const BackButtonWidget({
    super.key,
    required this.visible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),

      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            child: child,
          ),
        );
      },

      child: visible
          ? TextButton.icon(
              key: const ValueKey("back"),

              onPressed: onPressed,

              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 6),
              ),

              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),

              label: Text(
                "Back",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ).animate().fadeIn().slideX(begin: -.2)
          : const SizedBox(key: ValueKey("empty"), width: 70),
    );
  }
}
