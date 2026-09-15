import '../entities/cart_entity.dart';

abstract class CartRepository {
  /// Get all cart items
  Future<List<CartEntity>> getCartItems();

  /// Add product to cart
  Future<void> addToCart(CartEntity item);

  /// Remove product from cart
  Future<void> removeFromCart(int productId);

  /// Update product quantity
  Future<void> updateQuantity(int productId, int quantity);

  /// Clear all cart
  Future<void> clearCart();
}
