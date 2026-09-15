import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../checkout/presentation/screens/checkout_screen.dart';

class CartSummary extends StatelessWidget {
  final int totalItems;
  final double totalPrice;

  const CartSummary({
    super.key,
    required this.totalItems,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    const shipping = 0.0;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RowItem(title: "Items", value: "$totalItems"),

            const SizedBox(height: 14),

            _RowItem(
              title: "Subtotal",
              value: "\$${totalPrice.toStringAsFixed(2)}",
            ),

            const SizedBox(height: 14),

            const _RowItem(title: "Shipping", value: "Free"),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Divider(color: AppColors.grey300),
            ),

            Row(
              children: [
                const Text("Total", style: AppTextStyles.titleLarge),
                const Spacer(),
                Text(
                  "\$${(totalPrice + shipping).toStringAsFixed(2)}",
                  style: AppTextStyles.price,
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Proceed to Checkout",
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String title;
  final String value;

  const _RowItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey700),
        ),
        const Spacer(),
        Text(value, style: AppTextStyles.titleMedium),
      ],
    );
  }
}
