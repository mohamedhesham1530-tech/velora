import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/theme_extensions.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onTap;

  const FavoriteButton({super.key, this.isFavorite = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        width: 42,
        height: 42,

        decoration: BoxDecoration(
          color: context.card,
          shape: BoxShape.circle,

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFavorite
              ? context.colors.error
              : context.colors.onSurface.withOpacity(0.72),
          size: 22,
        ),
      ),
    ).animate().fadeIn().scale(duration: 450.ms, curve: Curves.easeOutBack);
  }
}
