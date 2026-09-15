import 'package:flutter/material.dart';

import 'package:e_commerce/core/theme/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int length;

  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) {
          final isSelected = currentIndex == index;

          return AnimatedContainer(
            duration: const Duration(
              milliseconds: 300,
            ),

            curve: Curves.easeInOut,

            margin: const EdgeInsets.symmetric(
              horizontal: 4,
            ),

            width: isSelected ? 28 : 8,
            height: 8,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),

              color: isSelected
                  ? AppColors.primary
                  : AppColors.grey300,
            ),
          );
        },
      ),
    );
  }
}