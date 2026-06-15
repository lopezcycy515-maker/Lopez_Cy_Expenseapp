import 'package:flutter/material.dart';

class AppBreakpoints {
  static const phone = 480.0;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  bool get isPhone => screenWidth < AppBreakpoints.phone;

  double horizontalPadding([double? phone, double? desktop]) {
    return isPhone ? (phone ?? 12) : (desktop ?? 16);
  }
}
