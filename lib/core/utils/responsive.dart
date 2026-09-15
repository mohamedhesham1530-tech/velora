import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isMobile => screenWidth < 600;

  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  bool get isDesktop => screenWidth >= 1024;

  double wp(double percent) {
    return screenWidth * percent;
  }

  double hp(double percent) {
    return screenHeight * percent;
  }

  double responsive({required double mobile, double? tablet, double? desktop}) {
    if (isDesktop) {
      return desktop ?? tablet ?? mobile;
    }

    if (isTablet) {
      return tablet ?? mobile;
    }

    return mobile;
  }

  double get maxContentWidth {
    if (isDesktop) return 450;

    if (isTablet) return 420;

    return screenWidth;
  }
}
