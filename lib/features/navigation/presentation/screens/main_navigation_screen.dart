import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';

import '../../../home/presentation/screens/home_screen.dart';
import '../../../wishlist/presentation/screens/wishlist_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

import '../cubit/navigation_cubit.dart';
import '../cubit/navigation_state.dart';
import '../widgets/bottom_nav_bar.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MainNavigationView();
  }
}

class _MainNavigationView extends StatelessWidget {
  const _MainNavigationView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        final pages = <Widget>[
          const HomeScreen(),
          const WishlistScreen(),
          const CartScreen(),
          const ProfileScreen(),
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(index: state.currentIndex, children: pages),
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }
}
