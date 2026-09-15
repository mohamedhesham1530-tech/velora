import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../screens/all_products_screen.dart';
import 'category_item.dart';
import 'section_title.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.categories != current.categories ||
          previous.selectedCategory != current.selectedCategory ||
          previous.allProducts != current.allProducts,
      builder: (context, state) {
        final categories = [
          'all',
          ...state.categories.map((category) => category.name),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // Section Title
            // =========================
            SectionTitle(
              title: 'home.categories'.tr(),
              onSeeAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AllProductsScreen(products: state.allProducts),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // =========================
            // Categories
            // =========================
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(categories.length, (index) {
                  final categoryName = categories[index];

                  final isAll = categoryName.toLowerCase() == 'all';

                  return Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: index == categories.length - 1 ? 0 : 18,
                    ),
                    child: CategoryItem(
                      title: _localizedCategoryName(categoryName),
                      icon: _iconFor(categoryName),
                      color: _colorFor(context, index),
                      isSelected: isAll
                          ? state.selectedCategory == null
                          : state.selectedCategory?.toLowerCase() ==
                                categoryName.toLowerCase(),
                      onTap: () {
                        context.read<HomeCubit>().selectCategory(categoryName);
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // Category Localization
  // =========================================================

  String _localizedCategoryName(String category) {
    final normalized = category
        .trim()
        .toLowerCase()
        .replaceAll('_', '-')
        .replaceAll(' ', '-');

    const categoryKeys = {
      'all': 'categories.all',

      'beauty': 'categories.beauty',
      'fragrances': 'categories.fragrances',
      'furniture': 'categories.furniture',

      'mens-shirts': 'categories.mensShirts',
      'mens-shoes': 'categories.mensShoes',
      'mens-watches': 'categories.mensWatches',

      'womens-bags': 'categories.womensBags',
      'womens-dresses': 'categories.womensDresses',
      'womens-jewellery': 'categories.womensJewellery',
      'womens-shoes': 'categories.womensShoes',
      'womens-watches': 'categories.womensWatches',

      'tops': 'categories.tops',

      'skin-care': 'categories.skinCare',
      'sunglasses': 'categories.sunglasses',

      'laptops': 'categories.laptops',
      'smartphones': 'categories.smartphones',
      'tablets': 'categories.tablets',
      'mobile-accessories': 'categories.mobileAccessories',

      'electronics': 'categories.electronics',

      'furnitures': 'categories.furniture',

      'groceries': 'categories.groceries',

      'kitchen-accessories': 'categories.kitchenAccessories',

      'sports-accessories': 'categories.sportsAccessories',

      'motorcycle': 'categories.motorcycle',
      'vehicle': 'categories.vehicle',
    };

    final key = categoryKeys[normalized];

    if (key != null) {
      return key.tr();
    }

    // Fallback for unknown categories
    return _formatCategoryName(category);
  }

  // =========================================================
  // Fallback Category Name
  // =========================================================

  String _formatCategoryName(String category) {
    return category
        .trim()
        .split(RegExp(r'[-_ ]+'))
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  // =========================================================
  // Category Icons
  // =========================================================

  IconData _iconFor(String category) {
    final value = category.toLowerCase();

    if (value.contains('beauty') || value.contains('skin')) {
      return Icons.face_retouching_natural_rounded;
    }

    if (value.contains('fragrance') || value.contains('perfume')) {
      return Icons.spa_rounded;
    }

    if (value.contains('furniture')) {
      return Icons.chair_alt_rounded;
    }

    if (value.contains('shoe')) {
      return Icons.hiking_rounded;
    }

    if (value.contains('sport')) {
      return Icons.sports_basketball_rounded;
    }

    if (value.contains('watch')) {
      return Icons.watch_rounded;
    }

    if (value.contains('jewellery') || value.contains('jewelry')) {
      return Icons.diamond_outlined;
    }

    if (value.contains('bag')) {
      return Icons.shopping_bag_outlined;
    }

    if (value.contains('shirt') || value.contains('tops')) {
      return Icons.checkroom_rounded;
    }

    if (value.contains('phone') ||
        value.contains('smartphone') ||
        value.contains('mobile') ||
        value.contains('laptop') ||
        value.contains('tablet') ||
        value.contains('electronic')) {
      return Icons.devices_rounded;
    }

    if (value.contains('kitchen')) {
      return Icons.kitchen_rounded;
    }

    if (value.contains('grocery')) {
      return Icons.shopping_cart_outlined;
    }

    if (value.contains('sunglasses')) {
      return Icons.wb_sunny_outlined;
    }

    if (value.contains('motorcycle') || value.contains('vehicle')) {
      return Icons.directions_car_rounded;
    }

    if (value == 'all') {
      return Icons.grid_view_rounded;
    }

    return Icons.category_rounded;
  }

  // =========================================================
  // Category Color
  // =========================================================

  Color _colorFor(BuildContext context, int index) {
    return context.primary;
  }
}
