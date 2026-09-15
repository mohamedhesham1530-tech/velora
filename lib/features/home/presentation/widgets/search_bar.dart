import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/responsive.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onVoiceTap;
  final ValueChanged<String>? onChanged;

  const HomeSearchBar({
    super.key,
    this.controller,
    this.onTap,
    this.onFilterTap,
    this.onVoiceTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.responsive(
        mobile: 62,
        tablet: 66,
        desktop: 70,
      ),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: context.colors.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: context.primary.withValues(alpha: .06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),

          Icon(
            Icons.search_rounded,
            color: context.colors.onSurface.withValues(alpha: 0.72),
            size: 24,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: TextField(
              controller: controller,
              onTap: onTap,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Search Products',
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: AppTextStyles.bodyLarge.copyWith(
                color: context.colors.onSurface,
              ),
              cursorColor: context.primary,
            ),
          ),

          GestureDetector(
            onTap: onVoiceTap,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: context.primary.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mic_none_rounded,
                color: context.primary,
              ),
            ),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: context.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 10),
        ],
      ),
    ).animate().fadeIn().slideY(
          begin: .15,
          duration: 500.ms,
        );
  }
}