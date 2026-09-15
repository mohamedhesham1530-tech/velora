import '../../domain/entities/order_entity.dart';
import '../../domain/repository/orders_repository.dart';
import '../datasource/orders_local_datasource.dart';
import '../models/order_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersLocalDataSource localDataSource;

  const OrdersRepositoryImpl({required this.localDataSource});

  @override
  Future<List<OrderEntity>> getOrders() => localDataSource.getOrders();

  @override
  Future<void> addOrder(OrderEntity order) =>
      localDataSource.addOrder(OrderModel.fromEntity(order));

  @override
  Future<void> clearOrders() => localDataSource.clearOrders();
}
