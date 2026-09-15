import '../../domain/entities/home_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../datasource/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  const HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HomeEntity> getHomeData() async {
    final products = await remoteDataSource.getProducts();
    final categoryNames = products
        .map((product) => product.category)
        .toSet()
        .toList()
      ..sort();

    return HomeEntity(
      banners: const [],
      categories: categoryNames
          .map((category) => CategoryEntity(name: category))
          .toList(),

      // جميع المنتجات
      allProducts: products,

      // تقسيم المنتجات للواجهة الرئيسية
      flashSale: products.take(10).toList(),
      featuredProducts: products.skip(10).take(10).toList(),
      recommendedProducts: products.skip(20).take(10).toList(),
    );
  }
}
