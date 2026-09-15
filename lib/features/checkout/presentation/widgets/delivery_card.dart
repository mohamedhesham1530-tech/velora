import 'package:flutter/material.dart';

import '../../../../core/theme/text_styles.dart';

class DeliveryCard extends StatelessWidget {
  const DeliveryCard({super.key});

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
                  Icons.local_shipping_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Delivery Method',
                style: AppTextStyles.titleLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          RadioListTile<String>(
            value: 'standard',
            groupValue: 'standard',
            onChanged: (_) {},
            title: const Text('Standard Delivery'),
            subtitle: const Text('2 - 4 Business Days'),
          ),

          RadioListTile<String>(
            value: 'express',
            groupValue: 'standard',
            onChanged: (_) {},
            title: const Text('Express Delivery'),
            subtitle: const Text('Same Day Delivery'),
          ),
        ],
      ),
    );
  }
}
