import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/responsive.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final circleSize = context.responsive(
      mobile: 74,
      tablet: 82,
      desktop: 90,
    );

    final itemWidth = context.responsive(
      mobile: 86,
      tablet: 94,
      desktop: 100,
    );

    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final dividerColor = theme.dividerColor;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    final onSurface = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: itemWidth,
        child: Column(
          children: [
            // =========================
            // Category Circle
            // =========================
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : cardColor,
                border: Border.all(
                  color: isSelected ? color : dividerColor,
                  width: isSelected ? 2.4 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? color.withValues(alpha: .25)
                        : dividerColor.withValues(alpha: .35),
                    blurRadius: isSelected ? 20 : 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  icon,
                  key: ValueKey(isSelected),
                  color: isSelected ? Colors.white : onSurfaceVariant,
                  size: context.responsive(
                    mobile: 34,
                    tablet: 38,
                    desktop: 42,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // Category Name
            // =========================
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              textDirection: Directionality.of(context),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? color : onSurface,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 350.ms,
        )
        .scale(
          duration: 500.ms,
          curve: Curves.easeOutBack,
        );
  }
}