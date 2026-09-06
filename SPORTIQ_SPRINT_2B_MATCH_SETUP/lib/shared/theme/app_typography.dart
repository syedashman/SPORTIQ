// Typography hierarchy. Design reference specifies Inter (body/UI) and
// Geist (display/headline), but those font files are not bundled yet
// (TODO: add approved font files, see TODO.md). Until then this falls
// back to the platform default font (null = system font) so the app does
// not reference missing assets. Swapping in the real fonts later only
// requires changing the two constants below plus re-adding the `fonts:`
// section in pubspec.yaml — no other file needs to change.
// Exact type-scale sizes are marked verify during implementation per
// DESIGN_SYSTEM.md.
import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTypography {
  AppTypography._();

  // TODO: restore 'Inter' / 'Geist' once approved font files are added to
  // assets/fonts/ and re-declared in pubspec.yaml.
  static const String? bodyFontFamily = null;
  static const String? displayFontFamily = null;

  static TextTheme get textTheme => const TextTheme(
        displayLarge: TextStyle(
          fontFamily: displayFontFamily,
          fontWeight: FontWeight.w800,
          fontSize: 40,
          color: AppColors.onBackground,
        ),
        displayMedium: TextStyle(
          fontFamily: displayFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 32,
          color: AppColors.onBackground,
        ),
        headlineLarge: TextStyle(
          fontFamily: displayFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 28,
          color: AppColors.onBackground,
        ),
        headlineMedium: TextStyle(
          fontFamily: displayFontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: AppColors.onBackground,
        ),
        titleLarge: TextStyle(
          fontFamily: bodyFontFamily,
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: AppColors.onBackground,
        ),
        titleMedium: TextStyle(
          fontFamily: bodyFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: AppColors.onBackground,
        ),
        bodyLarge: TextStyle(
          fontFamily: bodyFontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: AppColors.onBackground,
        ),
        bodyMedium: TextStyle(
          fontFamily: bodyFontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontFamily: bodyFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: AppColors.onBackground,
        ),
        labelMedium: TextStyle(
          fontFamily: bodyFontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: AppColors.onSurfaceVariant,
        ),
      );
}
