import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';

import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await DioClient.dio.get(ApiConstants.products);
    final data = response.data;
    if (data is! Map) {
      throw const FormatException('Unexpected products response.');
    }
    final rawProducts = data['products'];
    if (rawProducts is! List) {
      throw const FormatException('Products response does not contain a list.');
    }

    final products = <ProductModel>[];
    for (final rawProduct in rawProducts.whereType<Map>()) {
      try {
        products.add(ProductModel.fromJson(Map<String, dynamic>.from(rawProduct)));
      } on FormatException {
        // A malformed record should not make the entire home feed unavailable.
      }
    }

    return products;
  }
}
