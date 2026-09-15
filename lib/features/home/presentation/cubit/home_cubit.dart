import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_error_message.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/repository/home_repository.dart';
import 'home_state.dart';
import 'home_status.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeCubit({required this.repository}) : super(const HomeState());

  int _requestVersion = 0;

  Future<void> loadHome() async {
    final requestVersion = ++_requestVersion;
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));
    try {
      final home = await repository.getHomeData();
      if (isClosed || requestVersion != _requestVersion) return;
      final loadedState = state.copyWith(
        status: HomeStatus.success,
        categories: home.categories,
        allProducts: home.allProducts,
        flashSale: home.flashSale,
        featuredProducts: home.featuredProducts,
        recommendedProducts: home.recommendedProducts,
      );
      emit(loadedState.copyWith(displayedProducts: _filterProducts(loadedState)));
    } catch (error) {
      if (isClosed || requestVersion != _requestVersion) return;
      emit(state.copyWith(status: HomeStatus.failure, errorMessage: AppErrorMessage.from(error, fallback: 'We could not load the store right now. Please try again.')));
    }
  }

  void searchProducts(String query) => _apply(state.copyWith(searchQuery: query));

  void selectCategory(String? category) => _apply(
    category == null || category.toLowerCase() == 'all'
        ? state.copyWith(clearSelectedCategory: true)
        : state.copyWith(selectedCategory: category),
  );

  void updateFilters({
    ProductSort? sort,
    double? minimumRating,
    bool clearMinimumRating = false,
    double? minimumDiscount,
    bool clearMinimumDiscount = false,
    bool? inStockOnly,
  }) => _apply(state.copyWith(
    sort: sort,
    minimumRating: minimumRating,
    clearMinimumRating: clearMinimumRating,
    minimumDiscount: minimumDiscount,
    clearMinimumDiscount: clearMinimumDiscount,
    inStockOnly: inStockOnly,
  ));

  void clearProductControls() => _apply(state.copyWith(
    searchQuery: '',
    clearSelectedCategory: true,
    sort: ProductSort.none,
    clearMinimumRating: true,
    clearMinimumDiscount: true,
    inStockOnly: false,
  ));

  void _apply(HomeState nextState) =>
      emit(nextState.copyWith(displayedProducts: _filterProducts(nextState)));

  List<ProductEntity> _filterProducts(HomeState source) {
    final query = source.searchQuery.trim().toLowerCase();
    final products = source.allProducts.where((product) {
      final matchesQuery = query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
      final matchesCategory = source.selectedCategory == null ||
          product.category.toLowerCase() == source.selectedCategory!.toLowerCase();
      return matchesQuery &&
          matchesCategory &&
          (source.minimumRating == null || product.rating >= source.minimumRating!) &&
          (source.minimumDiscount == null || product.discountPercentage >= source.minimumDiscount!) &&
          (!source.inStockOnly || product.stock > 0);
    }).toList();
    switch (source.sort) {
      case ProductSort.priceLowToHigh:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSort.priceHighToLow:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSort.none:
        break;
    }
    return List<ProductEntity>.unmodifiable(products);
  }
}
