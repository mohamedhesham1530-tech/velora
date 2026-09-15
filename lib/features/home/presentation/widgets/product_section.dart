import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../navigation/presentation/cubit/navigation_cubit.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/show_success_cart_banner.dart';

import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';

import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';
import '../../domain/entities/product_entity.dart';
import '../screens/product_details/product_details_screen.dart';
import 'product_card.dart';
import 'section_title.dart';

class ProductSection extends StatelessWidget {
  final String title;
  final List<ProductEntity> products;
  final VoidCallback? onSeeAll;

  const ProductSection({
    super.key,
    required this.title,
    required this.products,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: title, onSeeAll: onSeeAll),

        SizedBox(height: context.hp(.02)),

        SizedBox(
          height: context.responsive(mobile: 390, tablet: 410, desktop: 430),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 18),
            itemBuilder: (context, index) {
              final product = products[index];

              return BlocSelector<WishlistCubit, WishlistState, bool>(
                selector: (state) => state.isFavorite(product),
                builder: (context, isFavorite) {
                  return ProductCard(
                    product: product,
                    isFavorite: isFavorite,
                    width: context.responsive(mobile: 210, tablet: 235, desktop: 255),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailsScreen(product: product),
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
        ),
      ],
    );
  }
}
