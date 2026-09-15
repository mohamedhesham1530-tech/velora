import 'package:equatable/equatable.dart';

import '../../../cart/domain/entities/cart_entity.dart';
import '../../../checkout/domain/entities/address_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final List<CartEntity> items;
  final AddressEntity address;
  final double totalPrice;
  final DateTime createdAt;
  final String status;

  OrderEntity({
    required this.id,
    required List<CartEntity> items,
    required this.address,
    required this.totalPrice,
    required this.createdAt,
    this.status = "Pending",
  }) : items = List<CartEntity>.unmodifiable(items);

  @override
  List<Object?> get props => [id, items, address, totalPrice, createdAt, status];
}
