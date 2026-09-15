import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/responsive.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/cubit/profile_state.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../checkout/presentation/screens/address_screen.dart';

import '../../domain/entities/product_entity.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../cubit/home_status.dart';

import '../widgets/categories_section.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/offers_carousel.dart';
import '../widgets/product_section.dart';
import '../widgets/product_filters_sheet.dart';
import '../widgets/search_bar.dart';

import 'all_products_screen.dart';
import 'notifications_screen.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // =========================
        // Loading
        // =========================
        if (state.status == HomeStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // =========================
        // Failure
        // =========================
        if (state.status == HomeStatus.failure) {
          return Center(
            child: Text(
              'home.noProductsFound'.tr(),
            ),
          );
        }

        // =========================
        // Home Content
        // =========================
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: context.wp(.05),
              vertical: context.hp(.02),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================
                // Profile / App Bar
                // =========================
                BlocSelector<
                    ProfileCubit,
                    ProfileState,
                    ({String name, String? photoUrl})>(
                  selector: (profileState) {
                    final user = profileState.user;

                    final name = user?.displayName?.trim();

                    return (
                      name: name != null && name.isNotEmpty
                          ? name
                          : 'home.welcome'.tr(),
                      photoUrl: user?.photoUrl,
                    );
                  },
                  builder: (context, profile) {
                    return HomeAppBar(
                      userName: profile.name,
                      imageUrl: profile.photoUrl,
                      location: 'Mansoura, Egypt',

                      // =========================
                      // Profile
                      // =========================
                      onAvatarTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },

                      // =========================
                      // Notifications
                      // =========================
                      onNotificationTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        );
                      },

                      // =========================
                      // Location
                      // =========================
                      onLocationTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddressScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),

                SizedBox(
                  height: context.hp(.03),
                ),

                // =========================
                // Search
                // =========================
                HomeSearchBar(
                  onChanged: context.read<HomeCubit>().searchProducts,
                  onFilterTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: false,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                      ),
                      builder: (_) {
                        return BlocProvider.value(
                          value: context.read<HomeCubit>(),
                          child: const ProductFiltersSheet(),
                        );
                      },
                    );
                  },
                ),

                SizedBox(
                  height: context.hp(.03),
                ),

                // =========================
                // Offers
                // =========================
                const OffersCarousel(),

                SizedBox(
                  height: context.hp(.04),
                ),

                // =========================
                // Categories
                // =========================
                const CategoriesSection(),

                SizedBox(
                  height: context.hp(.04),
                ),

                // =========================
                // Products
                // =========================
                if (state.hasActiveProductControls)
                  _FilteredProducts(
                    products: state.displayedProducts,
                  )
                else ...[
                  _HomeProductSection(
                    title: 'home.flashSale'.tr(),
                    products: state.flashSale,
                  ),

                  SizedBox(
                    height: context.hp(.04),
                  ),

                  _HomeProductSection(
                    title: 'home.featuredProducts'.tr(),
                    products: state.featuredProducts,
                  ),

                  SizedBox(
                    height: context.hp(.04),
                  ),

                  _HomeProductSection(
                    title: 'home.recommendedForYou'.tr(),
                    products: state.recommendedProducts,
                  ),
                ],

                SizedBox(
                  height: context.hp(.03),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =========================================================
// Home Product Section
// =========================================================

class _HomeProductSection extends StatelessWidget {
  final String title;
  final List<ProductEntity> products;

  const _HomeProductSection({
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return ProductSection(
      title: title,
      products: products,
      onSeeAll: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AllProductsScreen(
              products: products,
            ),
          ),
        );
      },
    );
  }
}

// =========================================================
// Filtered Products
// =========================================================

class _FilteredProducts extends StatelessWidget {
  final List<ProductEntity> products;

  const _FilteredProducts({
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    // =========================
    // No Products
    // =========================
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 54,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off_rounded,
                size: 60,
                color: Color(0xFF5B52FF),
              ),

              const SizedBox(
                height: 16,
              ),

              Text(
                'home.noProductsFound'.tr(),
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                'home.adjustFilters'.tr(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // =========================
    // Products Found
    // =========================
    return ProductSection(
      title: '${'home.products'.tr()} (${products.length})',
      products: products,
      onSeeAll: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AllProductsScreen(
              products: products,
            ),
          ),
        );
      },
    );
  }
}