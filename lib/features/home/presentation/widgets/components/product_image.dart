import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/utils/responsive.dart';

class ProductImage extends StatelessWidget {
  final String? imageUrl;
  final Object? heroTag;

  const ProductImage({super.key, this.imageUrl, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final size = context.responsive(mobile: 120, tablet: 145, desktop: 165);
    final tag = heroTag ?? (imageUrl?.isNotEmpty == true ? imageUrl! : 'product-image-placeholder');

    return Hero(
      tag: tag,
      child: Container(
        width: double.infinity,
        height: size,

        decoration: BoxDecoration(
          color: context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(22),
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: imageUrl == null || imageUrl!.isEmpty
              ? Icon(
                  Icons.shopping_bag_outlined,
                  size: size * .42,
                  color: context.colors.onSurface.withOpacity(0.56),
                )
              : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.broken_image_outlined,
                    size: size * .42,
                    color: context.colors.onSurface.withOpacity(0.56),
                  ),
                ),
        ),
      ),
    );
  }
}
