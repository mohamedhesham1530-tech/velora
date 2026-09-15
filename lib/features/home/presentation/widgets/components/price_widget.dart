import 'package:flutter/material.dart';

import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_extensions.dart';

class PriceWidget extends StatelessWidget {
  final double price;
  final double? oldPrice;

  const PriceWidget({super.key, required this.price, this.oldPrice});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          "\$${price.toStringAsFixed(2)}",
          style: AppTextStyles.price.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        if (oldPrice != null) ...[
          const SizedBox(width: 4),

          Text(
            "\$${oldPrice!.toStringAsFixed(2)}",
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colors.onSurface.withOpacity(0.56),
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }
}
