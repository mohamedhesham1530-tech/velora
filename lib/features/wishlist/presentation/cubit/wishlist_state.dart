import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/product_entity.dart';

class WishlistState extends Equatable {
  final List<ProductEntity> products;

  const WishlistState({this.products = const []});

  bool isFavorite(ProductEntity product) {
    return products.any((item) => item.id == product.id);
  }

  WishlistState copyWith({List<ProductEntity>? products}) {
    return WishlistState(products: products ?? this.products);
  }

  @override
  List<Object?> get props => [products];
}
