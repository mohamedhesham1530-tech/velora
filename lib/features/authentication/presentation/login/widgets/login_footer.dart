import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';

class LoginFooter extends StatelessWidget {
  final VoidCallback? onSignUp;

  const LoginFooter({
    super.key,
    this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey700,
            ),
          ),

          TextButton(
            onPressed: onSignUp,

            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
            ),

            child: Text(
              "Sign Up",
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
        .fadeIn(delay: 900.ms)
        .slideY(begin: .25);
  }
}