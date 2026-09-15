import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/text_styles.dart';
import '../../../../domain/entities/product_entity.dart';

class ProductPriceSection extends StatelessWidget {
  final ProductEntity product;

  const ProductPriceSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final oldPrice = product.price / (1 - (product.discountPercentage / 100));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: AppTextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          product.category[0].toUpperCase() + product.category.substring(1),
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey700),
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: AppTextStyles.price.copyWith(fontSize: 30),
            ),

            const SizedBox(width: 12),

            Text(
              "\$${oldPrice.toStringAsFixed(2)}",
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.grey500,
                decoration: TextDecoration.lineThrough,
              ),
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(.10),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "-${product.discountPercentage.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
