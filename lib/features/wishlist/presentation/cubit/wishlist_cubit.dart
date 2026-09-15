import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final NotificationCubit? notificationCubit;

  WishlistCubit({this.notificationCubit}) : super(const WishlistState());

  void toggleFavorite(ProductEntity product) {
    final products = List<ProductEntity>.from(state.products);

    final exists = products.any((item) => item.id == product.id);

    if (exists) {
      products.removeWhere((item) => item.id == product.id);
      notificationCubit?.addNotification(
        title: 'Wishlist Updated',
        body: '${product.title} removed from Wishlist.',
        iconName: 'favorite',
      );
    } else {
      products.add(product);
      notificationCubit?.addNotification(
        title: 'Wishlist Updated',
        body: '${product.title} added to Wishlist.',
        iconName: 'favorite',
      );
    }

    emit(state.copyWith(products: products));
  }

  void add(ProductEntity product) {
    if (state.isFavorite(product)) return;

    emit(state.copyWith(products: [...state.products, product]));
  }

  void remove(ProductEntity product) {
    emit(
      state.copyWith(
        products: state.products
            .where((item) => item.id != product.id)
            .toList(),
      ),
    );
  }

  void clearWishlist() {
    emit(const WishlistState());
  }

  bool isFavorite(ProductEntity product) {
    return state.isFavorite(product);
  }
}
