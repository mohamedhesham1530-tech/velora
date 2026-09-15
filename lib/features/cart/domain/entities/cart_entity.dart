class CartEntity {
  final int productId;
  final String title;
  final String category;
  final String image;
  final double price;
  final double discountPercentage;
  final double rating;
  final int quantity;

  const CartEntity({
    required this.productId,
    required this.title,
    required this.category,
    required this.image,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.quantity,
  });

  double get totalPrice => price * quantity;

  CartEntity copyWith({
    int? productId,
    String? title,
    String? category,
    String? image,
    double? price,
    double? discountPercentage,
    double? rating,
    int? quantity,
  }) {
    return CartEntity(
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
