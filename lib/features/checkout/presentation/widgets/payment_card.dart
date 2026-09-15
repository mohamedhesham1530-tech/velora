import 'package:flutter/material.dart';

import '../../../../core/theme/text_styles.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
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
                  color: theme.colorScheme.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.payment_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Payment Method',
                style: AppTextStyles.titleLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          RadioListTile<String>(
            value: 'cash',
            groupValue: 'cash',
            onChanged: (_) {},
            title: const Text('Cash on Delivery'),
            subtitle: const Text('Pay when your order arrives'),
          ),

          RadioListTile<String>(
            value: 'card',
            groupValue: 'cash',
            onChanged: (_) {},
            title: const Text('Credit / Debit Card'),
            subtitle: const Text('Visa, Mastercard'),
          ),

          RadioListTile<String>(
            value: 'paypal',
            groupValue: 'cash',
            onChanged: (_) {},
            title: const Text('PayPal'),
            subtitle: const Text('Pay securely using PayPal'),
          ),
        ],
      ),
    );
  }
}
