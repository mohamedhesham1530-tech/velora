import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/product_entity.dart';

import 'components/add_to_cart_button.dart';
import 'components/discount_badge.dart';
import 'components/favorite_button.dart';
import 'components/price_widget.dart';
import 'components/product_image.dart';
import 'components/rating_badge.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final bool isFavorite;

  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddToCart;

  final double? width;

  const ProductCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
    this.onAddToCart,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // SAFE DISCOUNT / PRICE CALCULATION
    // ============================================================

    final double safeDiscount = product.discountPercentage
        .clamp(0, 99.99)
        .toDouble();

    final double discountFactor = 1 - (safeDiscount / 100);

    final double? oldPrice =
        safeDiscount > 0 && product.price > 0 && discountFactor > 0
        ? product.price / discountFactor
        : null;

    final String discount = '-${safeDiscount.toStringAsFixed(0)}%';

    // ============================================================
    // SAFE CATEGORY
    // ============================================================

    final String category = product.category.trim();

    final String categoryName = category.isEmpty
        ? 'products.uncategorized'.tr()
        : category[0].toUpperCase() + category.substring(1);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width ?? double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: context.primary.withValues(alpha: .06),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              // ========================================================
              // IMAGE
              //
              // IMPORTANT:
              // Expanded makes the image consume ONLY the remaining
              // available space. This is the main fix for the
              // RenderFlex bottom overflow.
              // ========================================================
              Expanded(
                flex: 5,
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: ProductImage(
                          imageUrl: product.thumbnail,
                          heroTag: 'product-image-${product.id}',
                        ),
                      ),

                      // Discount
                      if (safeDiscount > 0)
                        PositionedDirectional(
                          start: 8,
                          top: 8,
                          child: DiscountBadge(discount: discount),
                        ),

                      // Favorite
                      PositionedDirectional(
                        end: 8,
                        top: 8,
                        child: FavoriteButton(
                          isFavorite: isFavorite,
                          onTap: onFavoriteTap,
                        ),
                      ),

                      // Rating
                      PositionedDirectional(
                        start: 8,
                        bottom: 8,
                        child: RatingBadge(rating: product.rating),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 5),

              // ========================================================
              // PRODUCT TITLE
              // ========================================================
              SizedBox(
                height: 38,
                width: double.infinity,
                child: Text(
                  product.title.trim().isEmpty
                      ? 'products.unnamed'.tr()
                      : product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: Directionality.of(context),
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
              ),

              const SizedBox(height: 1),

              // ========================================================
              // CATEGORY
              // ========================================================
              SizedBox(
                height: 16,
                width: double.infinity,
                child: Text(
                  categoryName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: Directionality.of(context),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.onSurface.withValues(alpha: 0.72),
                  ),
                ),
              ),

              const SizedBox(height: 3),

              // ========================================================
              // PRICE
              // ========================================================
              SizedBox(
                height: 25,
                width: double.infinity,
                child: PriceWidget(price: product.price, oldPrice: oldPrice),
              ),

              const SizedBox(height: 3),

              // ========================================================
              // ADD TO CART DIVIDER
              // ========================================================
              SizedBox(
                height: 14,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: context.colors.outlineVariant,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Flexible(
                      child: Text(
                        'products.addToCart'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.colors.onSurface.withValues(
                            alpha: 0.72,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Container(
                        height: 1,
                        color: context.colors.outlineVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 3),

              // ========================================================
              // SHIPPING + ADD TO CART
              // ========================================================
              SizedBox(
                height: 38,
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'products.freeShipping'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: Directionality.of(context),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 0,
                        maxHeight: 38,
                      ),
                      child: AddToCartButton(onPressed: onAddToCart),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
