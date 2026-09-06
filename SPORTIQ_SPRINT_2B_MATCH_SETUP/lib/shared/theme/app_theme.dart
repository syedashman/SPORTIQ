// Single centralized ThemeData for the whole app. Every widget must consume
// this theme (via Theme.of(context) or component-level *Theme classes) —
// never hardcode colors, spacing, or radius inline.
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final colorScheme = const ColorScheme.dark().copyWith(
      surface: AppColors.surface,
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.onErrorContainer,
      outline: AppColors.outline,
      onSurface: AppColors.onBackground,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,
      fontFamily: AppTypography.bodyFontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceRaised,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdRadius,
          side: const BorderSide(color: AppColors.glassStroke),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceBright,
        selectedColor: AppColors.primaryContainer,
        labelStyle: AppTypography.textTheme.labelMedium!,
        secondaryLabelStyle: AppTypography.textTheme.labelMedium!.copyWith(
          color: AppColors.onPrimaryContainer,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.fullRadius),
        side: const BorderSide(color: AppColors.glassStroke),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimaryContainer,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.fullRadius),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onBackground,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          side: const BorderSide(color: AppColors.outline),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.fullRadius),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondary,
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceRaised,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(color: AppColors.glassStroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(
            color: AppColors.primaryContainer,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTypography.textTheme.bodyMedium,
        labelStyle: AppTypography.textTheme.bodyMedium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceRaised,
        indicatorColor: AppColors.primaryContainer,
        labelTextStyle: WidgetStateProperty.all(
          AppTypography.textTheme.labelMedium,
        ),
        height: 64,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceRaised,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
        titleTextStyle: AppTypography.textTheme.titleLarge,
        contentTextStyle: AppTypography.textTheme.bodyMedium,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.md),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.outline,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.glassStroke,
        thickness: 1,
        space: AppSpacing.md,
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.error,
        textColor: AppColors.onError,
      ),
    );
  }
}
