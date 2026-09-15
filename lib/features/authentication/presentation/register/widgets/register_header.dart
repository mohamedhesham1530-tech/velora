import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/utils/responsive.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final logoSize = context.responsive(
      mobile: 100,
      tablet: 115,
      desktop: 125,
    );

    return Column(
      children: [
        Container(
          width: logoSize,
          height: logoSize,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),

            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff7C73FF),
                Color(0xff5B52FF),
              ],
            ),

            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.25),
                blurRadius: 35,
                offset: const Offset(0, 18),
              ),
            ],
          ),

          child: const Icon(
            Icons.person_add_alt_1_rounded,
            color: Colors.white,
            size: 50,
          ),
        )
            .animate()
            .scale(
              duration: 600.ms,
              curve: Curves.easeOutBack,
            )
            .fadeIn(),

        SizedBox(height: context.hp(.03)),

        Text(
          "Create Account",
          textAlign: TextAlign.center,
          style: AppTextStyles.displayLarge.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: context.responsive(
              mobile: 30,
              tablet: 34,
              desktop: 38,
            ),
          ),
        )
            .animate()
            .slideY(begin: .20)
            .fadeIn(),

        const SizedBox(height: 12),

        SizedBox(
          width: context.responsive(
            mobile: context.wp(.82),
            tablet: 430,
            desktop: 470,
          ),
          child: Text(
            "Create your Velora account and start exploring thousands of premium products.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.grey700,
              height: 1.6,
            ),
          ),
        )
            .animate()
            .fadeIn(
              delay: 250.ms,
            ),
      ],
    );
  }
}