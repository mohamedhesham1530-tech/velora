import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static final List<BoxShadow> small = [
    BoxShadow(
      color: Colors.black.withOpacity(.05),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(.08),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];

  static final List<BoxShadow> large = [
    BoxShadow(
      color: Colors.black.withOpacity(.12),
      blurRadius: 28,
      offset: const Offset(0, 14),
    ),
  ];

  static final List<BoxShadow> primary = [
    BoxShadow(
      color: const Color(0xFF5B52FF).withOpacity(.18),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];
}
