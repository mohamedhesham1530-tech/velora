import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/responsive.dart';

class LocationWidget extends StatelessWidget {
  final String location;
  final VoidCallback? onTap;

  const LocationWidget({super.key, required this.location, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,

            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.10),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.location_on_rounded,
              size: 16,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Deliver to",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey700,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: context.responsive(
                      mobile: 15,
                      tablet: 16,
                      desktop: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.grey700,
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -.10, duration: 500.ms);
  }
}
