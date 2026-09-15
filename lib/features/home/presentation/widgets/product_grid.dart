import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/show_success_cart_banner.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../navigation/presentation/cubit/navigation_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';
import '../../domain/entities/product_entity.dart';
import '../screens/product_details/product_details_screen.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductEntity> products;

  const ProductGrid({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No products found.'),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1100
            ? 4
            : width >= 700
                ? 3
                : 2;

        final mainAxisExtent = crossAxisCount == 2
            ? (width < 380 ? 365.0 : 375.0)
            : crossAxisCount == 3
                ? 375.0
                : 390.0;

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            mainAxisExtent: mainAxisExtent,
          ),
          itemBuilder: (context, index) {
            final product = products[index];

            return BlocSelector<WishlistCubit, WishlistState, bool>(
              selector: (state) => state.isFavorite(product),
              builder: (context, isFavorite) {
                return ProductCard(
                  product: product,
                  isFavorite: isFavorite,
                  onTap: () {
                    Navigator.of(context).push(
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
                        if (!context.mounted) return;
                        context.read<NavigationCubit>().changeTab(2);
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
