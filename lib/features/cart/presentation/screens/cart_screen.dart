import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/text_styles.dart';

import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../cubit/cart_status.dart';

import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary.dart';
import '../widgets/empty_cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _refresh() async {
    await context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "My Cart",
          style: AppTextStyles.headlineMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),

      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.loading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.items.isEmpty) {
            return const EmptyCart();
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            color: theme.colorScheme.primary,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${state.totalItems} Items",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.72),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (context, index) {
                      return CartItemCard(item: state.items[index]);
                    },
                  ),
                ),

                CartSummary(
                  totalItems: state.totalItems,
                  totalPrice: state.totalPrice,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
