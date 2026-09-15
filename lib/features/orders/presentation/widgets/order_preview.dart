import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/order_entity.dart';

class OrderPreview extends StatelessWidget {
  final OrderEntity order;
  final bool expanded;

  const OrderPreview({super.key, required this.order, this.expanded = false});

  @override
  Widget build(BuildContext context) {
    final items = expanded ? order.items : order.items.take(3).toList();
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: item.image,
                      width: expanded ? 64 : 46,
                      height: expanded ? 64 : 46,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: expanded ? 64 : 46,
                        height: expanded ? 64 : 46,
                        color: context.colors.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'x${item.quantity}',
                    style: context.text.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: context.text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
