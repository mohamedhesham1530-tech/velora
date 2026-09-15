import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  final bool showArrow;

  final bool hasSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  final String? badge;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.showArrow = true,
    this.hasSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: theme.cardTheme.color ?? colors.surface,

        borderRadius: BorderRadius.circular(22),

        elevation: theme.brightness == Brightness.dark ? 0 : 1,

        shadowColor: colors.shadow.withValues(
          alpha: theme.brightness == Brightness.dark ? .20 : .12,
        ),

        child: InkWell(
          borderRadius: BorderRadius.circular(22),

          onTap: hasSwitch ? null : onTap,

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

            child: Row(
              children: [
                // =====================================================
                // Icon
                // =====================================================
                Container(
                  width: 46,
                  height: 46,

                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Icon(icon, color: colors.primary),
                ),

                const SizedBox(width: 16),

                // =====================================================
                // Title + Subtitle
                // =====================================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: Directionality.of(context),

                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),

                      if (subtitle != null) ...[
                        const SizedBox(height: 4),

                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textDirection: Directionality.of(context),

                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // =====================================================
                // Badge
                // =====================================================
                if (badge != null) ...[
                  const SizedBox(width: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],

                // =====================================================
                // Switch
                // =====================================================
                if (hasSwitch) ...[
                  const SizedBox(width: 8),

                  Switch(value: switchValue, onChanged: onSwitchChanged),
                ]
                // =====================================================
                // Arrow
                // =====================================================
                else if (showArrow) ...[
                  const SizedBox(width: 8),

                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: .1);
  }
}
