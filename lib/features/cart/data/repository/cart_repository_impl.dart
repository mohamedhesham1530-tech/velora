import '../../domain/entities/cart_entity.dart';
import '../../domain/repository/cart_repository.dart';

import '../datasource/cart_local_datasource.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  const CartRepositoryImpl({required this.localDataSource});

  @override
  Future<List<CartEntity>> getCartItems() async {
    return await localDataSource.getCartItems();
  }

  @override
  Future<void> addToCart(CartEntity item) async {
    await localDataSource.addToCart(CartModel.fromEntity(item));
  }

  @override
  Future<void> removeFromCart(int productId) async {
    await localDataSource.removeFromCart(productId);
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    await localDataSource.updateQuantity(productId, quantity);
  }

  @override
  Future<void> clearCart() async {
    await localDataSource.clearCart();
  }
}
