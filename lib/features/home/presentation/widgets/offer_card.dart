import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/responsive.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String discount;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback? onTap;

  const OfferCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.discount,
    required this.backgroundColor,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.responsive(
          mobile: context.wp(.88),
          tablet: 500,
          desktop: 620,
        ),

        // تم زيادة الارتفاع قليلًا لحل مشكلة Overflow
        height: context.responsive(mobile: 195, tablet: 210, desktop: 230),

        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(.35),
              blurRadius: 30,
              offset: const Offset(0, 18),
            ),
          ],
        ),

        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.18),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      discount,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: context.wp(.04)),

            Container(
              width: context.responsive(mobile: 90, tablet: 110, desktop: 130),
              height: context.responsive(mobile: 90, tablet: 110, desktop: 130),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: context.responsive(mobile: 50, tablet: 60, desktop: 70),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: .15).scale();
  }
}
