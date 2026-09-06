// Centralized color tokens extracted from the SPORTIQ Stitch design export.
// DO NOT hardcode colors anywhere else in the app — always reference AppColors.
import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();

  // Surfaces
  static const Color background = Color(0xFF0C1609);
  static const Color surface = Color(0xFF0E150B);
  static const Color surfaceDim = Color(0xFF0E150B);
  static const Color surfaceBright = Color(0xFF333B2F);
  static const Color surfaceRaised = Color(0xFF171717);
  static const Color surfaceBase = Color(0xFF0D0D0D);

  // Primary
  static const Color primary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF79FF5B);
  static const Color primaryFixedDim = Color(0xFF5CE141);
  static const Color onPrimaryContainer = Color(0xFF127500);
  static const Color onPrimaryFixed = Color(0xFF022100);
  static const Color onPrimaryFixedVariant = Color(0xFF0A5300);

  // Secondary
  static const Color secondary = Color(0xFFABC7FF);
  static const Color onSecondary = Color(0xFF002F65);
  static const Color onSecondaryContainer = Color(0xFFF2F4FF);

  // Tertiary
  static const Color tertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFDAD5);
  static const Color tertiaryFixed = Color(0xFFFFDAD5);
  static const Color tertiaryFixedDim = Color(0xFFFFB4AB);
  static const Color onTertiary = Color(0xFF51221D);
  static const Color onTertiaryFixed = Color(0xFF360E0A);
  static const Color onTertiaryFixedVariant = Color(0xFF6C3832);

  // Error
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // Outline / on-colors
  static const Color outline = Color(0xFF87957F);
  static const Color onBackground = Color(0xFFDDE5D4);
  static const Color onSurfaceVariant = Color(0xFFBDCBB3);
  static const Color inverseSurface = Color(0xFFDDE5D4);
  static const Color inverseOnSurface = Color(0xFF2B3327);

  // Glass / decorative
  static const Color glassStroke = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
}
