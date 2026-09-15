import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/utils/responsive.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final logoSize = context.responsive(mobile: 95, tablet: 110, desktop: 120);

    return Column(
      children: [
        Container(
          width: logoSize,
          height: logoSize,

          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff7C73FF), Color(0xff5B52FF)],
            ),

            borderRadius: BorderRadius.circular(28),

            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.25),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),

          child: const Icon(
            Icons.shopping_bag_rounded,
            color: Colors.white,
            size: 46,
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),

        SizedBox(height: context.hp(.03)),

        Text(
          "Welcome Back",
          style: AppTextStyles.displayLarge.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: context.responsive(mobile: 30, tablet: 34, desktop: 38),
          ),
        ).animate().slideY(begin: .25).fadeIn(),

        const SizedBox(height: 10),

        Text(
          "Sign in to continue shopping with Velora.",
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.grey700,
            height: 1.6,
          ),
        ).animate().fadeIn(delay: 250.ms),
      ],
    );
  }
}
