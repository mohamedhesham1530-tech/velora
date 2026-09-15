import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/firebase_auth_service.dart';
import '../theme/theme_cubit.dart';
import '../localization/localization_cubit.dart';
import 'package:e_commerce/core/services/location/location_service.dart';

// Navigation
import '../../features/navigation/presentation/cubit/navigation_cubit.dart';

// Authentication
import '../../features/authentication/data/datasources/firebase_auth_datasource.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/presentation/cubit/login/login_cubit.dart';
import '../../features/authentication/presentation/cubit/register/register_cubit.dart';

// Home
import '../../features/home/data/datasource/home_remote_datasource.dart';
import '../../features/home/data/repository/home_repository_impl.dart';
import '../../features/home/domain/repository/home_repository.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

// Cart
import '../../features/cart/data/datasource/cart_local_datasource.dart';
import '../../features/cart/data/repository/cart_repository_impl.dart';
import '../../features/cart/domain/repository/cart_repository.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';

// Wishlist
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';

// Address
import '../../features/checkout/data/datasource/address_local_datasource.dart';
import '../../features/checkout/data/repository/address_repository_impl.dart';
import '../../features/checkout/domain/repository/address_repository.dart';
import '../../features/checkout/presentation/cubit/address_cubit.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

// Notifications
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/presentation/cubit/notification_cubit.dart';

// Orders
import '../../features/orders/data/datasource/orders_local_datasource.dart';
import '../../features/orders/data/repository/orders_repository_impl.dart';
import '../../features/orders/domain/repository/orders_repository.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  //==========================
  // Shared Preferences
  //==========================

  final prefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      preferences: sl(),
      authService: sl(),
    ),
  );
  sl.registerLazySingleton<NotificationCubit>(
    () => NotificationCubit(repository: sl()),
  );
  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(preferences: sl(), notificationCubit: sl()),
  );
 sl.registerLazySingleton<LocalizationCubit>(
  () => LocalizationCubit(
    preferences: sl(),
  ),
);

  //==========================
  // Core Services
  //==========================

  sl.registerLazySingleton<LocationService>(() => const LocationService());

  //==========================
  // Firebase
  //==========================

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());

  //==========================
  // Authentication
  //==========================

  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(
      authService: sl(),
      firestore: sl(),
      storage: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => LoginCubit(repository: sl()));

  sl.registerFactory(() => RegisterCubit(repository: sl()));
  sl.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(repository: sl(), notificationCubit: sl()),
  );

  //==========================
  // Home
  //==========================

  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => HomeCubit(repository: sl()));

  //==========================
  // Cart (LOCAL)
  //==========================

  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(
      prefs: sl(),
      authService: sl(),
    ),
  );

  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<CartCubit>(
    () => CartCubit(repository: sl(), notificationCubit: sl()),
  );

  //==========================
  // Address
  //==========================

  sl.registerLazySingleton<AddressLocalDataSource>(
    () => AddressLocalDataSource(
      sharedPreferences: sl(),
      authService: sl(),
    ),
  );

  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<AddressCubit>(() => AddressCubit(sl()));

  //==========================
  // Navigation
  //==========================

  sl.registerLazySingleton<NavigationCubit>(() => NavigationCubit());

  //==========================
  // Wishlist
  //==========================

  sl.registerLazySingleton<WishlistCubit>(
    () => WishlistCubit(notificationCubit: sl()),
  );

  //==========================
  // Orders
  //==========================

  sl.registerLazySingleton<OrdersLocalDataSource>(
    () => OrdersLocalDataSourceImpl(
      prefs: sl(),
      authService: sl(),
    ),
  );

  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<OrdersCubit>(
    () => OrdersCubit(repository: sl(), notificationCubit: sl()),
  );
}
