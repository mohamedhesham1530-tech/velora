import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/screens/order_success_screen.dart';
import '../cubit/address_cubit.dart';
import 'address_card.dart';

class CheckoutBody extends StatefulWidget {
  const CheckoutBody({super.key});

  @override
  State<CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<CheckoutBody> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
            child: Row(
              children: [
                IconButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: AddressCard(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: theme.cardColor),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: _isSubmitting
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : const Text('Place Order'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    final address = context.read<AddressCubit>().state.address;
    final cartCubit = context.read<CartCubit>();
    final ordersCubit = context.read<OrdersCubit>();
    final cartState = cartCubit.state;

    if (address == null) {
      _showMessage('Please add a shipping address before placing your order.');
      return;
    }
    if (cartState.items.isEmpty) {
      _showMessage('Your cart is empty. Add an item before placing an order.');
      return;
    }

    setState(() => _isSubmitting = true);
    final order = OrderEntity(
      id: 'VL-${DateTime.now().microsecondsSinceEpoch}',
      items: cartState.items,
      address: address,
      totalPrice: cartState.totalPrice,
      createdAt: DateTime.now(),
    );

    try {
      await ordersCubit.addOrder(order);
      await cartCubit.clearCart();
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: order)),
      );
    } catch (_) {
      if (mounted) {
        _showMessage('We could not place your order. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
