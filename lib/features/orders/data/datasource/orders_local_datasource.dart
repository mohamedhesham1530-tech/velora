import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/firebase_auth_service.dart';
import '../models/order_model.dart';

abstract class OrdersLocalDataSource {
  Future<List<OrderModel>> getOrders();
  Future<void> addOrder(OrderModel order);
  Future<void> clearOrders();
}

class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  static const _baseOrdersKey = 'orders';

  final SharedPreferences prefs;
  final FirebaseAuthService authService;

  const OrdersLocalDataSourceImpl({
    required this.prefs,
    required this.authService,
  });

  String? get _storageKey {
    final uid = authService.currentUser?.uid;
    return uid == null ? null : '${_baseOrdersKey}_$uid';
  }

  String _requireStorageKey() {
    final key = _storageKey;
    if (key == null) {
      throw StateError('No authenticated user is available for order storage.');
    }
    return key;
  }

  Future<List<OrderModel>> _read(String key) async {
    final savedOrders = prefs.getString(key);
    if (savedOrders == null || savedOrders.isEmpty) return [];

    try {
      final decoded = jsonDecode(savedOrders);
      if (decoded is! List) {
        await prefs.remove(key);
        return [];
      }

      final orders = <OrderModel>[];
      for (final value in decoded.whereType<Map>()) {
        try {
          orders.add(OrderModel.fromJson(Map<String, dynamic>.from(value)));
        } catch (_) {
          // Preserve valid orders when one persisted record is malformed.
        }
      }
      return orders;
    } catch (_) {
      await prefs.remove(key);
      return [];
    }
  }

  Future<void> _save(String key, List<OrderModel> orders) async {
    final saved = await prefs.setString(
      key,
      jsonEncode(orders.map((order) => order.toJson()).toList()),
    );
    if (!saved) throw StateError('Unable to save order.');
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final key = _storageKey;
    if (key == null) return [];
    return _read(key);
  }

  @override
  Future<void> addOrder(OrderModel order) async {
    final key = _requireStorageKey();
    final orders = await _read(key);
    orders.insert(0, order);
    await _save(key, orders);
  }

  @override
  Future<void> clearOrders() async {
    final key = _storageKey;
    if (key == null) return;

    if (prefs.containsKey(key) && !(await prefs.remove(key))) {
      throw StateError('Unable to clear orders.');
    }
  }
}
