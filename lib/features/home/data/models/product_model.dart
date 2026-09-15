import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.brand,
    required super.description,
    required super.category,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.stock,
    required super.thumbnail,
    required super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! num) {
      throw const FormatException('Product id is missing or invalid.');
    }

    String stringValue(String key) => json[key] is String ? json[key] as String : '';
    double numberValue(String key) => (json[key] as num?)?.toDouble() ?? 0;
    int integerValue(String key) => (json[key] as num?)?.toInt() ?? 0;
    final rawImages = json['images'];

    return ProductModel(
      id: id.toInt(),
      title: stringValue('title'),
      brand: stringValue('brand'),
      description: stringValue('description'),
      category: stringValue('category'),
      price: numberValue('price'),
      discountPercentage: numberValue('discountPercentage'),
      rating: numberValue('rating'),
      stock: integerValue('stock'),
      thumbnail: stringValue('thumbnail'),
      images: rawImages is List
          ? rawImages.whereType<String>().where((url) => url.isNotEmpty).toList()
          : const [],
    );
  }
}
