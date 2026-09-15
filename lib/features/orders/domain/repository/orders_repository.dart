import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Future<List<OrderEntity>> getOrders();

  Future<void> addOrder(OrderEntity order);

  Future<void> clearOrders();
}
