import '../../../cart/data/models/cart_model.dart';
import '../../../checkout/data/models/address_model.dart';
import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.items,
    required super.address,
    required super.totalPrice,
    required super.createdAt,
    super.status,
  });

  factory OrderModel.fromEntity(OrderEntity entity) => OrderModel(
        id: entity.id,
        items: entity.items,
        address: entity.address,
        totalPrice: entity.totalPrice,
        createdAt: entity.createdAt,
        status: entity.status,
      );

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String,
        items: (json['items'] as List<dynamic>? ?? const [])
            .map((item) => CartModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
        address: AddressModel.fromJson(
          Map<String, dynamic>.from(json['address'] as Map),
        ),
        totalPrice: (json['totalPrice'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        status: json['status'] as String? ?? 'Pending',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((item) => CartModel.fromEntity(item).toJson()).toList(),
        'address': AddressModel(
          fullName: address.fullName,
          phone: address.phone,
          alternatePhone: address.alternatePhone,
          country: address.country,
          governorate: address.governorate,
          city: address.city,
          area: address.area,
          street: address.street,
          building: address.building,
          floor: address.floor,
          apartment: address.apartment,
          landmark: address.landmark,
          notes: address.notes,
          latitude: address.latitude,
          longitude: address.longitude,
          isDefault: address.isDefault,
        ).toJson(),
        'totalPrice': totalPrice,
        'createdAt': createdAt.toIso8601String(),
        'status': status,
      };
}
