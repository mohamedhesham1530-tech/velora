import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/text_styles.dart';

import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';

import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/cubit/orders_state.dart';

import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';

class ProfileStatistics extends StatelessWidget {
  const ProfileStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // =========================================================
        // Orders
        // =========================================================
        Expanded(
          child: BlocSelector<OrdersCubit, OrdersState, int>(
            selector: (state) => state.orders.length,
            builder: (_, count) {
              return _StatCard(
                title: 'profile.orders'.tr(),
                value: count.toString(),
                icon: Icons.inventory_2_outlined,
                color: Colors.blue,
              );
            },
          ),
        ),

        const SizedBox(width: 14),

        // =========================================================
        // Wishlist
        // =========================================================
        Expanded(
          child: BlocSelector<WishlistCubit, WishlistState, int>(
            selector: (state) => state.products.length,
            builder: (_, count) {
              return _StatCard(
                title: 'profile.wishlist'.tr(),
                value: count.toString(),
                icon: Icons.favorite_outline_rounded,
                color: Colors.redAccent,
              );
            },
          ),
        ),

        const SizedBox(width: 14),

        // =========================================================
        // Cart
        // =========================================================
        Expanded(
          child: BlocSelector<CartCubit, CartState, int>(
            selector: (state) => state.totalItems,
            builder: (_, count) {
              return _StatCard(
                title: 'profile.cart'.tr(),
                value: count.toString(),
                icon: Icons.shopping_cart_outlined,
                color: Colors.green,
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: .2);
  }
}

// ===================================================================
// Statistics Card
// ===================================================================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),

      decoration: BoxDecoration(
        // Uses the current theme automatically.
        color: theme.cardTheme.color ?? colors.surface,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(
              alpha: theme.brightness == Brightness.dark ? .20 : .08,
            ),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],

        // Very subtle border in dark mode
        border: theme.brightness == Brightness.dark
            ? Border.all(color: colors.outlineVariant, width: 1)
            : null,
      ),

      child: Column(
        children: [
          // =======================================================
          // Icon
          // =======================================================
          CircleAvatar(
            radius: 22,

            backgroundColor: color.withValues(
              alpha: theme.brightness == Brightness.dark ? .18 : .12,
            ),

            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 14),

          // =======================================================
          // Value
          // =======================================================
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 4),

          // =======================================================
          // Title
          // =======================================================
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            textDirection: Directionality.of(context),

            style: AppTextStyles.bodySmall.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
