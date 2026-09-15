import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final String title;
  final String brand;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String thumbnail;
  final List<String> images;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.brand,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    required this.images,
  });

  @override
  List<Object?> get props => [
    id, title, brand, description, category, price, discountPercentage,
    rating, stock, thumbnail, images,
  ];
}
