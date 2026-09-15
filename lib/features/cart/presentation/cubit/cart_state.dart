import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_entity.dart';
import 'cart_status.dart';

class CartState extends Equatable {
  final CartStatus status;
  final List<CartEntity> items;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  double get totalPrice => items.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    CartStatus? status,
    List<CartEntity>? items,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
