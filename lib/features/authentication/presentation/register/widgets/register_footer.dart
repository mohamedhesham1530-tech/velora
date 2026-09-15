import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';

class RegisterFooter extends StatelessWidget {
  final VoidCallback? onSignIn;

  const RegisterFooter({
    super.key,
    this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account?",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey700,
            ),
          ),

          TextButton(
            onPressed: onSignIn,

            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
            ),

            child: Text(
              "Sign In",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 700.ms)
        .slideY(begin: .20);
  }
}