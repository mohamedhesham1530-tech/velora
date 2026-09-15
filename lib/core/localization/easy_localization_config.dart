import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class EasyLocalizationConfig {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  static const Locale fallbackLocale = Locale('en');

  static const String path = 'assets/translations';

  static const String defaultLocale = 'en';

  static Widget build({
    required Widget child,
    required Locale startLocale,
  }) {
    return EasyLocalization(
      supportedLocales: supportedLocales,
      path: path,
      fallbackLocale: fallbackLocale,
      startLocale: startLocale,
      child: child,
    );
  }
}