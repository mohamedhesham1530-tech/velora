import 'package:e_commerce/features/cart/data/models/cart_model.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('defensive model parsing', () {
    test('product model accepts integer numeric API values', () {
      final product = ProductModel.fromJson({
        'id': 1,
        'title': 'Velora bag',
        'price': 99,
        'discountPercentage': 10,
        'rating': 4,
        'stock': 2,
        'images': ['https://example.com/bag.png', 42],
      });

      expect(product.price, 99);
      expect(product.images, ['https://example.com/bag.png']);
    });

    test('cart model sanitizes invalid optional persisted values', () {
      final item = CartModel.fromJson({
        'productId': 1,
        'price': 12,
        'quantity': 0,
      });

      expect(item.quantity, 1);
      expect(item.title, isEmpty);
      expect(item.price, 12);
    });

    test('models reject records without a valid identifier', () {
      expect(
        () => ProductModel.fromJson(const {'title': 'Missing id'}),
        throwsFormatException,
      );
      expect(
        () => CartModel.fromJson(const {'productId': '1'}),
        throwsFormatException,
      );
    });
  });
}
