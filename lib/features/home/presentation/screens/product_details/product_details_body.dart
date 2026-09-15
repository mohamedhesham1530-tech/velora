import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../navigation/presentation/cubit/navigation_cubit.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../../../core/widgets/show_success_cart_banner.dart';

import '../../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../../wishlist/presentation/cubit/wishlist_state.dart';
import '../../../../../core/theme/theme_extensions.dart';

import '../../../../cart/domain/entities/cart_entity.dart';
import '../../../../cart/presentation/cubit/cart_cubit.dart';

import '../../widgets/product_details/product_image_slider.dart';
import '../../widgets/product_details/components/product_description_section.dart';
import '../../widgets/product_details/components/product_header.dart';
import '../../widgets/product_details/components/product_price_section.dart';
import '../../widgets/product_details/components/product_rating_section.dart';

class ProductDetailsBody extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailsBody({super.key, required this.product});

  @override
  State<ProductDetailsBody> createState() => _ProductDetailsBodyState();
}

class _ProductDetailsBodyState extends State<ProductDetailsBody> {
  bool _isAddingToCart = false;

  ProductEntity get product => widget.product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            children: [
              ProductHeader(
                onBack: () => Navigator.pop(context),
                isFavorite: state.isFavorite(product),
                onFavorite: () {
                  context.read<WishlistCubit>().toggleFavorite(product);
                },
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductImageSlider(
                        images: product.images.isNotEmpty ? product.images : [product.thumbnail],
                        heroTag: 'product-image-${product.id}',
                      ),

                      const SizedBox(height: 24),

                      ProductPriceSection(product: product),

                      const SizedBox(height: 22),

                      ProductRatingSection(product: product),

                      const SizedBox(height: 22),

                      ProductDescriptionSection(
                        description: product.description,
                      ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: _isAddingToCart
                          ? null
                          : () async {
                              setState(() => _isAddingToCart = true);

                              try {
                                final success =
                                    await context.read<CartCubit>().addToCart(
                                      CartEntity(
                                        productId: product.id,
                                        title: product.title,
                                        category: product.category,
                                        image: product.thumbnail,
                                        price: product.price,
                                        discountPercentage:
                                            product.discountPercentage,
                                        rating: product.rating,
                                        quantity: 1,
                                      ),
                                    );

                                if (!mounted || !success) return;

                                showSuccessCartBanner(
                                  context: context,
                                  title: product.title,
                                  image: product.thumbnail,
                                  onViewCart: () {
                                    if (!mounted) return;
                                    context
                                        .read<NavigationCubit>()
                                        .changeTab(2);
                                  },
                                );
                              } finally {
                                if (mounted) {
                                  setState(() => _isAddingToCart = false);
                                }
                              }
                            },
                      icon: _isAddingToCart
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.shopping_bag_outlined),
                      label: Text(
                        _isAddingToCart ? 'Adding…' : 'Add To Cart',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
