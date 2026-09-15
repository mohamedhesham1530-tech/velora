import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../widgets/order_card.dart';
import '../widgets/order_preview.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Order Details', style: TextStyle(fontWeight: FontWeight.w800)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            _Section(
              title: 'Order information',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _InfoRow(label: 'Order ID', value: order.id),
                _InfoRow(label: 'Order date', value: formatOrderDate(order.createdAt)),
                _InfoRow(label: 'Status', value: order.status, highlighted: true),
              ]),
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'Shipping address',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(order.address.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(order.address.phone, style: const TextStyle(color: AppColors.grey700)),
                const SizedBox(height: 10),
                Text('${order.address.street}, ${order.address.area}\n${order.address.city}, ${order.address.governorate}, ${order.address.country}', style: const TextStyle(color: AppColors.grey700, height: 1.5)),
              ]),
            ),
            const SizedBox(height: 16),
            _Section(title: 'Products (${order.items.length})', child: OrderPreview(order: order, expanded: true)),
            const SizedBox(height: 16),
            _Section(
              title: 'Payment summary',
              child: _InfoRow(label: 'Order total', value: '\$${order.totalPrice.toStringAsFixed(2)}', bold: true),
            ),
          ],
        ),
      );
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(22)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          child,
        ]),
      );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool highlighted;
  const _InfoRow({required this.label, required this.value, this.bold = false, this.highlighted = false});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Text(label, style: const TextStyle(color: AppColors.grey700)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: bold || highlighted ? FontWeight.w800 : FontWeight.w600, color: highlighted ? AppColors.warning : null)),
        ]),
      );
}
