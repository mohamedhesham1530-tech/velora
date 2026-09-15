import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../navigation/presentation/cubit/navigation_cubit.dart';
import '../../domain/entities/order_entity.dart';
import 'orders_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderEntity order;
  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 116,
                height: 116,
                decoration: BoxDecoration(color: AppColors.success.withOpacity(.12), shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: AppColors.success, size: 68),
              ).animate().scale(curve: Curves.elasticOut, duration: 700.ms),
              const SizedBox(height: 30),
              const Text('Order Placed Successfully', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              const Text('Your order has been received.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.grey700, fontSize: 16)),
              const SizedBox(height: 12),
              Text(order.id, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
              const SizedBox(height: 48),
              SizedBox(width: double.infinity, height: 56, child: ElevatedButton(
                onPressed: () {
                  context.read<NavigationCubit>().changeTab(0);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Continue Shopping'),
              )),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, height: 56, child: OutlinedButton(
                onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const OrdersScreen())),
                child: const Text('View My Orders'),
              )),
            ]),
          ),
        ),
      );
}
