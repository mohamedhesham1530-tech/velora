import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/utils/responsive.dart';

class OnBoardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const OnBoardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageSize = context.responsive(
          mobile: constraints.maxWidth * .60,
          tablet: 280,
          desktop: 320,
        );

        final iconBoxSize = context.responsive(
          mobile: imageSize * .68,
          tablet: 180,
          desktop: 200,
        );

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.maxContentWidth),
            child: Column(
              children: [
                const Spacer(),

                Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(.08),
                      ),

                      child: Center(
                        child: Container(
                          width: iconBoxSize,
                          height: iconBoxSize,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),

                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xff7C73FF), Color(0xff5B52FF)],
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(.25),
                                blurRadius: 35,
                                offset: const Offset(0, 18),
                              ),
                            ],
                          ),

                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: context.responsive(
                              mobile: 64,
                              tablet: 78,
                              desktop: 86,
                            ),
                          ),
                        ),
                      ),
                    )
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.easeOutBack)
                    .fadeIn(),

                const SizedBox(height: 28),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.displayLarge.copyWith(
                    fontSize: context.responsive(
                      mobile: 34,
                      tablet: 38,
                      desktop: 42,
                    ),
                    fontWeight: FontWeight.w800,
                  ),
                ).animate().slideY(begin: .25).fadeIn(),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.grey700,
                      height: 1.6,
                      fontSize: context.responsive(
                        mobile: 16,
                        tablet: 17,
                        desktop: 18,
                      ),
                    ),
                  ).animate().fadeIn(delay: 250.ms),
                ),

                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
