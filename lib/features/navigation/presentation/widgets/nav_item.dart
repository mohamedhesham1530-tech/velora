import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/text_styles.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // =========================================================
    // Colors
    // =========================================================

    final selectedColor = colorScheme.primary;

    final unselectedColor = colorScheme.onSurfaceVariant;

    return Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,

              padding: const EdgeInsets.symmetric(vertical: 10),

              decoration: BoxDecoration(
                // Selected background
                color: isSelected
                    ? selectedColor.withValues(alpha: .10)
                    : Colors.transparent,

                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ===================================================
                  // Icon
                  // ===================================================
                  AnimatedScale(
                    duration: const Duration(milliseconds: 250),

                    scale: isSelected ? 1.15 : 1,

                    child: Icon(
                      icon,

                      color: isSelected ? selectedColor : unselectedColor,

                      size: 26,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ===================================================
                  // Label
                  // ===================================================
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),

                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? selectedColor : unselectedColor,

                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),

                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(target: isSelected ? 1 : 0)
        .scale(begin: const Offset(.95, .95), end: const Offset(1, 1));
  }
}
