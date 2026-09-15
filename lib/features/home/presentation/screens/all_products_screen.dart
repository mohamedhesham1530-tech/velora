import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/show_success_cart_banner.dart';

import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';

import '../../../navigation/presentation/cubit/navigation_cubit.dart';

import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';

import '../../domain/entities/product_entity.dart';

import '../widgets/product_card.dart';
import 'product_details/product_details_screen.dart';

class AllProductsScreen extends StatelessWidget {
  final List<ProductEntity> products;

  final String? category;

  const AllProductsScreen({super.key, required this.products, this.category});

  @override
  Widget build(BuildContext context) {
    final normalizedCategory = category?.trim().toLowerCase();

    final filteredProducts = normalizedCategory == null
        ? products
        : products
              .where(
                (e) => e.category.trim().toLowerCase() == normalizedCategory,
              )
              .toList();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.background,
        title: Text(category ?? 'All Products'),
      ),

      body: GridView.builder(
        padding: EdgeInsets.all(context.wp(.04)),

        physics: const BouncingScrollPhysics(),

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context
              .responsive(mobile: 2, tablet: 3, desktop: 4)
              .toInt(),
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 0.65,
        ),
        itemCount: filteredProducts.length,

        itemBuilder: (context, index) {
          final product = filteredProducts[index];

          return BlocSelector<WishlistCubit, WishlistState, bool>(
            selector: (state) => state.isFavorite(product),
            builder: (context, isFavorite) {
              return ProductCard(
                product: product,

                isFavorite: isFavorite,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(product: product),
                    ),
                  );
                },

                onFavoriteTap: () {
                  context.read<WishlistCubit>().toggleFavorite(product);
                },

                onAddToCart: () async {
                  final success = await context.read<CartCubit>().addToCart(
                    CartEntity(
                      productId: product.id,
                      title: product.title,
                      category: product.category,
                      image: product.thumbnail,
                      price: product.price,
                      discountPercentage: product.discountPercentage,
                      rating: product.rating,
                      quantity: 1,
                    ),
                  );

                  if (!context.mounted || !success) return;
                  showSuccessCartBanner(
                    context: context,
                    title: product.title,
                    image: product.thumbnail,
                    onViewCart: () {
                      context.read<NavigationCubit>().changeTab(2);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
