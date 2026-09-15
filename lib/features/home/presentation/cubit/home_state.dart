import 'package:equatable/equatable.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import 'home_status.dart';

enum ProductSort { none, priceLowToHigh, priceHighToLow }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<CategoryEntity> categories;
  final List<ProductEntity> allProducts;
  final List<ProductEntity> flashSale;
  final List<ProductEntity> featuredProducts;
  final List<ProductEntity> recommendedProducts;
  final List<ProductEntity> displayedProducts;
  final String searchQuery;
  final String? selectedCategory;
  final ProductSort sort;
  final double? minimumRating;
  final double? minimumDiscount;
  final bool inStockOnly;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.categories = const [],
    this.allProducts = const [],
    this.flashSale = const [],
    this.featuredProducts = const [],
    this.recommendedProducts = const [],
    this.displayedProducts = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.sort = ProductSort.none,
    this.minimumRating,
    this.minimumDiscount,
    this.inStockOnly = false,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<CategoryEntity>? categories,
    List<ProductEntity>? allProducts,
    List<ProductEntity>? flashSale,
    List<ProductEntity>? featuredProducts,
    List<ProductEntity>? recommendedProducts,
    List<ProductEntity>? displayedProducts,
    String? searchQuery,
    String? selectedCategory,
    bool clearSelectedCategory = false,
    ProductSort? sort,
    double? minimumRating,
    bool clearMinimumRating = false,
    double? minimumDiscount,
    bool clearMinimumDiscount = false,
    bool? inStockOnly,
    String? errorMessage,
  }) => HomeState(
    status: status ?? this.status,
    categories: categories ?? this.categories,
    allProducts: allProducts ?? this.allProducts,
    flashSale: flashSale ?? this.flashSale,
    featuredProducts: featuredProducts ?? this.featuredProducts,
    recommendedProducts: recommendedProducts ?? this.recommendedProducts,
    displayedProducts: displayedProducts ?? this.displayedProducts,
    searchQuery: searchQuery ?? this.searchQuery,
    selectedCategory: clearSelectedCategory ? null : selectedCategory ?? this.selectedCategory,
    sort: sort ?? this.sort,
    minimumRating: clearMinimumRating ? null : minimumRating ?? this.minimumRating,
    minimumDiscount: clearMinimumDiscount ? null : minimumDiscount ?? this.minimumDiscount,
    inStockOnly: inStockOnly ?? this.inStockOnly,
    errorMessage: errorMessage,
  );

  bool get hasActiveProductControls =>
      searchQuery.isNotEmpty || selectedCategory != null || sort != ProductSort.none ||
      minimumRating != null || minimumDiscount != null || inStockOnly;

  @override
  List<Object?> get props => [
    status, categories, allProducts, flashSale, featuredProducts,
    recommendedProducts, displayedProducts, searchQuery, selectedCategory,
    sort, minimumRating, minimumDiscount, inStockOnly, errorMessage,
  ];
}
