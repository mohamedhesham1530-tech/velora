import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final subtotal = state.totalPrice;
        const double shipping = 50.0;
        const double discount = 0.0;
        final total = subtotal + shipping - discount;
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Order Summary',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _summaryRow('Items', '${state.totalItems}', theme: theme),
              const SizedBox(height: 12),

              _summaryRow(
                'Subtotal',
                '\$${subtotal.toStringAsFixed(2)}',
                theme: theme,
              ),

              const SizedBox(height: 12),

              _summaryRow(
                'Shipping',
                '\$${shipping.toStringAsFixed(2)}',
                theme: theme,
              ),

              const SizedBox(height: 12),

              _summaryRow(
                'Discount',
                '-\$${discount.toStringAsFixed(2)}',
                theme: theme,
              ),

              Divider(height: 32, color: theme.dividerColor),

              _summaryRow(
                'Total',
                '\$${total.toStringAsFixed(2)}',
                isTotal: true,
                theme: theme,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    bool isTotal = false,
    required ThemeData theme,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal
              ? AppTextStyles.titleMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                )
              : AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.72),
                ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.price.copyWith(color: theme.colorScheme.onSurface)
              : AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
        ),
      ],
    );
  }
}
