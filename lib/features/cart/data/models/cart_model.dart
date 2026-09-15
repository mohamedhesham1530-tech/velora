import '../../domain/entities/cart_entity.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.productId,
    required super.title,
    required super.category,
    required super.image,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final productId = json['productId'];
    if (productId is! num) {
      throw const FormatException('Cart product id is missing or invalid.');
    }

    String stringValue(String key) => json[key] is String ? json[key] as String : '';
    double numberValue(String key) => (json[key] as num?)?.toDouble() ?? 0;
    int positiveIntegerValue(String key) {
      final value = (json[key] as num?)?.toInt() ?? 1;
      return value > 0 ? value : 1;
    }

    return CartModel(
      productId: productId.toInt(),
      title: stringValue('title'),
      category: stringValue('category'),
      image: stringValue('image'),
      price: numberValue('price'),
      discountPercentage: numberValue('discountPercentage'),
      rating: numberValue('rating'),
      quantity: positiveIntegerValue('quantity'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'category': category,
      'image': image,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'quantity': quantity,
    };
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      productId: entity.productId,
      title: entity.title,
      category: entity.category,
      image: entity.image,
      price: entity.price,
      discountPercentage: entity.discountPercentage,
      rating: entity.rating,
      quantity: entity.quantity,
    );
  }

  CartModel copyWith({
    int? productId,
    String? title,
    String? category,
    String? image,
    double? price,
    double? discountPercentage,
    double? rating,
    int? quantity,
  }) {
    return CartModel(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      category: category ?? this.category,
      image: image ?? this.image,
      price: price ?? this.price,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      quantity: quantity ?? this.quantity,
    );
  }
}
