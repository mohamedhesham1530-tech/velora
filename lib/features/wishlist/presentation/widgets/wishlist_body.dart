import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../home/presentation/widgets/product_grid.dart';
import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_state.dart';

class WishlistBody extends StatelessWidget {
  const WishlistBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Wishlist",
                          style: AppTextStyles.headlineMedium,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: state.products.isEmpty
                          ? null
                          : () async {
                              final shouldClear = await showDialog<bool>(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Clear wishlist?'),
                                  content: const Text(
                                    'This will remove all saved products from your wishlist.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, true),
                                      child: const Text('Clear'),
                                    ),
                                  ],
                                ),
                              );

                              if (shouldClear == true && context.mounted) {
                                context.read<WishlistCubit>().clearWishlist();
                              }
                            },
                      icon: const Icon(Icons.delete_outline_rounded),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                if (state.products.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 80,
                            color: AppColors.grey500,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Your wishlist is empty",
                            style: AppTextStyles.headlineMedium,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Start adding products you love ❤️",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(child: ProductGrid(products: state.products)),
              ],
            ),
          );
        },
      ),
    );
  }
}
