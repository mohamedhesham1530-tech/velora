import 'product_entity.dart';
import 'category_entity.dart';
import 'banner_entity.dart';

class HomeEntity {
  final List<BannerEntity> banners;

  final List<CategoryEntity> categories;

  /// جميع المنتجات
  final List<ProductEntity> allProducts;

  final List<ProductEntity> flashSale;

  final List<ProductEntity> featuredProducts;

  final List<ProductEntity> recommendedProducts;

  const HomeEntity({
    required this.banners,
    required this.categories,
    required this.allProducts,
    required this.flashSale,
    required this.featuredProducts,
    required this.recommendedProducts,
  });
}
