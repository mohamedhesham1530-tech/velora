import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/service_locator.dart';
import 'core/services/firebase_auth_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/localization/localization_cubit.dart';

import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/checkout/presentation/cubit/address_cubit.dart';
import 'features/navigation/presentation/cubit/navigation_cubit.dart';
import 'features/notifications/presentation/cubit/notification_cubit.dart';
import 'features/orders/presentation/cubit/orders_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'features/splash/presentation/splash_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint('Flutter error: ${details.exception}');
      debugPrintStack(stackTrace: details.stack);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('Uncaught platform error: $error');
      debugPrintStack(stackTrace: stack);
      return false;
    };

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await initServiceLocator();

    final localizationCubit = sl<LocalizationCubit>();
    final savedLocale = localizationCubit.state;

    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: savedLocale,
        child: const VeloraApp(),
      ),
    );
  }, (error, stack) {
    debugPrint('Uncaught application error: $error');
    debugPrintStack(stackTrace: stack);
  });
}

class VeloraApp extends StatefulWidget {
  const VeloraApp({super.key});

  @override
  State<VeloraApp> createState() => _VeloraAppState();
}

class _VeloraAppState extends State<VeloraApp> {
  StreamSubscription<User?>? _authSubscription;
  String? _lastUid;
  bool _hasProcessedInitialAuthState = false;

  @override
  void initState() {
    super.initState();
    sl<ProfileCubit>().watchProfile();
    _authSubscription = sl<FirebaseAuthService>().authStateChanges.listen(
      _handleAuthStateChanged,
    );
  }

  void _handleAuthStateChanged(User? user) {
    final uid = user?.uid;
    if (_hasProcessedInitialAuthState && uid == _lastUid) return;

    _lastUid = uid;
    _hasProcessedInitialAuthState = true;
    unawaited(_syncUserScopedState(uid));
  }

  Future<void> _syncUserScopedState(String? uid) async {
    final cartCubit = sl<CartCubit>();
    final ordersCubit = sl<OrdersCubit>();
    final addressCubit = sl<AddressCubit>();
    final notificationCubit = sl<NotificationCubit>();
    final wishlistCubit = sl<WishlistCubit>();
    final navigationCubit = sl<NavigationCubit>();

    navigationCubit.changeTab(0);
    cartCubit.reset();
    ordersCubit.reset();
    addressCubit.reset();
    notificationCubit.reset();
    wishlistCubit.clearWishlist();

    if (uid == null) return;

    await Future.wait([
      cartCubit.loadCart(),
      ordersCubit.loadOrders(),
      addressCubit.loadAddress(),
      notificationCubit.loadNotifications(),
    ]);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationCubit>.value(value: sl<NotificationCubit>()),
        BlocProvider<WishlistCubit>.value(value: sl<WishlistCubit>()),
        BlocProvider<CartCubit>.value(value: sl<CartCubit>()),
        BlocProvider<OrdersCubit>.value(value: sl<OrdersCubit>()),
        BlocProvider<ProfileCubit>.value(value: sl<ProfileCubit>()),
        BlocProvider<ThemeCubit>.value(value: sl<ThemeCubit>()),
        BlocProvider<LocalizationCubit>.value(value: sl<LocalizationCubit>()),
        BlocProvider<NavigationCubit>.value(value: sl<NavigationCubit>()),
        BlocProvider<AddressCubit>.value(value: sl<AddressCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Velora',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            themeAnimationDuration: Duration.zero,
            themeAnimationCurve: Curves.linear,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: [
              ...context.localizationDelegates,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
