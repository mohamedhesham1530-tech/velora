import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/firebase_auth_service.dart';
import '../models/cart_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartModel>> getCartItems();

  Future<void> addToCart(CartModel item);

  Future<void> removeFromCart(int productId);

  Future<void> updateQuantity(int productId, int quantity);

  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _baseCartKey = 'cart_items';

  final SharedPreferences prefs;
  final FirebaseAuthService authService;

  const CartLocalDataSourceImpl({
    required this.prefs,
    required this.authService,
  });

  String? get _storageKey {
    final uid = authService.currentUser?.uid;
    return uid == null ? null : '${_baseCartKey}_$uid';
  }

  String _requireStorageKey() {
    final key = _storageKey;
    if (key == null) {
      throw StateError('No authenticated user is available for cart storage.');
    }
    return key;
  }

  Future<List<CartModel>> _read(String key) async {
    final jsonString = prefs.getString(key);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) {
        await prefs.remove(key);
        return [];
      }

      final items = <CartModel>[];
      for (final item in decoded.whereType<Map>()) {
        try {
          items.add(CartModel.fromJson(Map<String, dynamic>.from(item)));
        } on FormatException {
          // Keep valid persisted items when one old/corrupt record is invalid.
        } on TypeError {
          // Keep valid persisted items when one old/corrupt record is invalid.
        }
      }
      return items;
    } catch (_) {
      await prefs.remove(key);
      return [];
    }
  }

  Future<void> _save(String key, List<CartModel> items) async {
    final json = jsonEncode(items.map((e) => e.toJson()).toList());
    if (!await prefs.setString(key, json)) {
      throw StateError('Unable to save cart changes.');
    }
  }

  @override
  Future<List<CartModel>> getCartItems() async {
    final key = _storageKey;
    if (key == null) return [];
    return _read(key);
  }

  @override
  Future<void> addToCart(CartModel item) async {
    // Capture the user's key for the whole operation so an auth change during
    // an awaited storage operation cannot redirect the write to another user.
    final key = _requireStorageKey();
    final items = await _read(key);
    final index = items.indexWhere((e) => e.productId == item.productId);

    if (index != -1) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + item.quantity,
      );
    } else {
      items.add(item);
    }

    await _save(key, items);
  }

  @override
  Future<void> removeFromCart(int productId) async {
    final key = _requireStorageKey();
    final items = await _read(key);
    items.removeWhere((e) => e.productId == productId);
    await _save(key, items);
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    final key = _requireStorageKey();
    final items = await _read(key);
    final index = items.indexWhere((e) => e.productId == productId);

    if (index != -1) {
      items[index] = items[index].copyWith(quantity: quantity);
      await _save(key, items);
    }
  }

  @override
  Future<void> clearCart() async {
    final key = _storageKey;
    if (key == null) return;

    if (prefs.containsKey(key) && !(await prefs.remove(key))) {
      throw StateError('Unable to clear the cart.');
    }
  }
}
