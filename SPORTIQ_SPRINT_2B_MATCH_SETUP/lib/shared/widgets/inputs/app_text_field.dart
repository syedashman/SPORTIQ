// Standard text field — styled via InputDecorationTheme.
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.controller,
    this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.errorText,
    this.enabled = true,
    this.onChanged,
    this.suffixIcon,
    super.key,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
