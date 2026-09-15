import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../widgets/order_card.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.background,
    appBar: AppBar(
      title: Text(
        'My Orders',
        style: context.text.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: context.onSurface,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: context.onSurface,
    ),
    body: BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.isLoading && state.orders.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: context.primary),
          );
        }
        if (state.orders.isEmpty) return const _EmptyOrders();
        return RefreshIndicator(
          onRefresh: context.read<OrdersCubit>().loadOrders,
          color: context.primary,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            itemCount: state.orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) =>
                OrderCard(
                      order: state.orders[index],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              OrderDetailsScreen(order: state.orders[index]),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: (index * 60).ms)
                    .slideY(begin: .08, end: 0),
          ),
        );
      },
    ),
  );
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 116,
            height: 116,
            decoration: BoxDecoration(
              color: context.card,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 54,
              color: context.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No orders yet',
            style: context.text.titleMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: context.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your completed purchases will appear here.',
            textAlign: TextAlign.center,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    ),
  );
}
