import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppBorders {
  AppBorders._();

  static BorderSide grey = const BorderSide(color: AppColors.grey300, width: 1);

  static BorderSide primary = const BorderSide(
    color: AppColors.primary,
    width: 1.3,
  );

  static BorderSide error = const BorderSide(
    color: AppColors.error,
    width: 1.3,
  );

  static BorderSide white = const BorderSide(color: Colors.white, width: 1);
}
