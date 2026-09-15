import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get text => theme.textTheme;

  bool get isDark => theme.brightness == Brightness.dark;

  Color get background => theme.scaffoldBackgroundColor;

  Color get surface => colors.surface;

  Color get primary => colors.primary;

  Color get onPrimary => colors.onPrimary;

  Color get onSurface => colors.onSurface;

  Color get divider => theme.dividerColor;

  Color get card => theme.cardColor;
}