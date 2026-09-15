import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/navigation_cubit.dart';
import '../cubit/navigation_state.dart';
import 'nav_item.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              // يتغير تلقائيًا مع الـ Theme
              color: colorScheme.surface,

              borderRadius: BorderRadius.circular(24),

              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(
                    alpha: theme.brightness == Brightness.dark ? .30 : .08,
                  ),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
              ],

              border: theme.brightness == Brightness.dark
                  ? Border.all(color: colorScheme.outlineVariant, width: 1)
                  : null,
            ),

            child: Row(
              children: [
                // =====================================================
                // Home
                // =====================================================
                NavItem(
                  icon: Icons.home_rounded,
                  label: 'navigation.home'.tr(),
                  isSelected: state.currentIndex == 0,
                  onTap: () {
                    context.read<NavigationCubit>().changeTab(0);
                  },
                ),

                // =====================================================
                // Wishlist
                // =====================================================
                NavItem(
                  icon: Icons.favorite_rounded,
                  label: 'navigation.wishlist'.tr(),
                  isSelected: state.currentIndex == 1,
                  onTap: () {
                    context.read<NavigationCubit>().changeTab(1);
                  },
                ),

                // =====================================================
                // Cart
                // =====================================================
                NavItem(
                  icon: Icons.shopping_cart_rounded,
                  label: 'navigation.cart'.tr(),
                  isSelected: state.currentIndex == 2,
                  onTap: () {
                    context.read<NavigationCubit>().changeTab(2);
                  },
                ),

                // =====================================================
                // Profile
                // =====================================================
                NavItem(
                  icon: Icons.person_rounded,
                  label: 'navigation.profile'.tr(),
                  isSelected: state.currentIndex == 3,
                  onTap: () {
                    context.read<NavigationCubit>().changeTab(3);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
