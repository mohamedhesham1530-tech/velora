import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/app_dimensions.dart';
import 'package:e_commerce/core/theme/text_styles.dart';

class NextButton extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onPressed;

  const NextButton({
    super.key,
    required this.isLastPage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,

      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          elevation: 0,

          backgroundColor: AppColors.primary,

          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.radiusLg,
            ),
          ),

          shadowColor: AppColors.primary.withOpacity(.25),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 250,
              ),

              child: Text(
                isLastPage
                    ? "Get Started"
                    : "Next",

                key: ValueKey(isLastPage),

                style: AppTextStyles.button,
              ),
            ),

            const SizedBox(width: 10),

            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 250,
              ),

              child: Icon(
                isLastPage
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_rounded,

                key: ValueKey(isLastPage),

                size: 20,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(
          begin: .40,
          end: 0,
          curve: Curves.easeOut,
        );
  }
}