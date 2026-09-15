import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_extensions.dart';

class BackToLogin extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackToLogin({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Remember your password?",
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 6),

          TextButton.icon(
            onPressed: onPressed,

            style: TextButton.styleFrom(
              foregroundColor: context.primary,
            ),

            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
            ),

            label: Text(
              "Back to Login",
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: context.primary,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 650.ms)
        .slideY(begin: .20);
  }
}