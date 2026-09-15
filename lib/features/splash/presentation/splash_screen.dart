import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../navigation/presentation/screens/main_navigation_screen.dart';
import '../../onboarding/presentation/onboarding_screen.dart';
import './splash_body.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _splashDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _setupSystemUI();
    unawaited(_goNext());
  }

  void _setupSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _goNext() async {
    await Future<void>.delayed(_splashDuration);
    if (!mounted) return;

    final user = await sl<FirebaseAuthService>().authStateChanges.first;
    if (!mounted) return;

    final destination = user == null
        ? const OnBoardingScreen()
        : const MainNavigationScreen();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: destination,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: const SplashBody()
          .animate()
          .fadeIn(duration: 700.ms, curve: Curves.easeOut)
          .scale(
            begin: const Offset(.96, .96),
            end: const Offset(1, 1),
            duration: 800.ms,
            curve: Curves.easeOutBack,
          ),
    );
  }
}
