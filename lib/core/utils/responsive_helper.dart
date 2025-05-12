import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveHelper {
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static double getAdaptiveFontSize(BuildContext context, double baseSize) {
    if (isTablet(context)) {
      return baseSize * 1.2;
    }
    return baseSize;
  }

  static EdgeInsets getAdaptivePadding(BuildContext context) {
    if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h);
    }
    return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
  }

  static double getAdaptiveSpacing(BuildContext context) {
    if (isTablet(context)) {
      return 24.h;
    }
    return 16.h;
  }

  static int getGridCrossAxisCount(BuildContext context) {
    if (isTablet(context)) {
      return isLandscape(context) ? 3 : 2;
    }
    return 1;
  }
} 