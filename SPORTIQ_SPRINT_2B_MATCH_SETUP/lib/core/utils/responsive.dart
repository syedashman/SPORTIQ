// Responsive layout breakpoints and helpers per DESIGN_RULES.md.
// Phone-first; tablet behavior will be refined during implementation.

import 'package:flutter/material.dart';

enum ScreenSize { mobile, tablet, desktop }

abstract class Responsive {
  Responsive._();

  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  static ScreenSize of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < mobileMaxWidth) {
      return ScreenSize.mobile;
    }

    if (width < tabletMaxWidth) {
      return ScreenSize.tablet;
    }

    return ScreenSize.desktop;
  }

  static bool isMobile(BuildContext context) {
    return of(context) == ScreenSize.mobile;
  }

  static bool isTablet(BuildContext context) {
    return of(context) == ScreenSize.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return of(context) == ScreenSize.desktop;
  }

  static double horizontalPadding(BuildContext context) {
    switch (of(context)) {
      case ScreenSize.mobile:
        return 16;
      case ScreenSize.tablet:
        return 32;
      case ScreenSize.desktop:
        return 64;
    }
  }
}
