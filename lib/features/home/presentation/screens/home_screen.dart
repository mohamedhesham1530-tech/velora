import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/theme_extensions.dart';

import '../cubit/home_cubit.dart';
import 'home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // =========================================================
    // System UI
    // =========================================================

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,

        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );

    return Scaffold(
      // =======================================================
      // IMPORTANT:
      // Use Theme background instead of AppColors.background
      // =======================================================
      backgroundColor: context.background,

      body: BlocProvider(
        create: (_) => sl<HomeCubit>()..loadHome(),
        child: const HomeBody(),
      ),
    );
  }
}
