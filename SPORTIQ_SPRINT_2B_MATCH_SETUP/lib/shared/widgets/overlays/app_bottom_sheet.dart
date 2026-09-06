// Standard modal bottom sheet — styled via BottomSheetTheme. Use this for
// all dropdown-replacement pickers (sport selector, filters, role
// assignment) per DESIGN_RULES.md — no native dropdowns.
import 'package:flutter/material.dart';

class AppBottomSheet {
  AppBottomSheet._();

  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: builder,
    );
  }
}
