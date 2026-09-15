import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartModel>> getCartItems();

  Future<void> addToCart(CartModel item);

  Future<void> removeFromCart(int productId);

  Future<void> updateQuantity(int productId, int quantity);

  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const CartRemoteDataSourceImpl({required this.firestore, required this.auth});

  CollectionReference<Map<String, dynamic>> get _cartCollection {
    final user = auth.currentUser;
    if (user == null) throw StateError('No authenticated user found.');
    final uid = user.uid;

    return firestore.collection('users').doc(uid).collection('cart');
  }

  @override
  Future<List<CartModel>> getCartItems() async {
    final snapshot = await _cartCollection.get();
    final items = <CartModel>[];
    for (final document in snapshot.docs) {
      try {
        items.add(CartModel.fromJson(document.data()));
      } on FormatException {
        // Ignore only the malformed remote record and keep the cart usable.
      }
    }
    return items;
  }

  @override
  Future<void> addToCart(CartModel item) async {
    final doc = _cartCollection.doc(item.productId.toString());

    final snapshot = await doc.get();

    if (snapshot.exists) {
      final data = snapshot.data();
      final currentQuantity = (data?['quantity'] as num?)?.toInt() ?? 1;

      await doc.update({'quantity': currentQuantity + item.quantity});
    } else {
      await doc.set(item.toJson());
    }
  }

  @override
  Future<void> removeFromCart(int productId) async {
    await _cartCollection.doc(productId.toString()).delete();
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    await _cartCollection.doc(productId.toString()).update({
      'quantity': quantity,
    });
  }

  @override
  Future<void> clearCart() async {
    final snapshot = await _cartCollection.get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
