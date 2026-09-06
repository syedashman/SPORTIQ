// Status badge pill — used for role/status indicators (e.g. Live,
// Upcoming, Completed, role tags). Colors come from AppColors semantic
// tokens, never hardcoded.
import 'package:flutter/material.dart';
import '../../theme/theme.dart';

enum AppBadgeVariant { neutral, success, error, info }

class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    this.variant = AppBadgeVariant.neutral,
    super.key,
  });

  final String label;
  final AppBadgeVariant variant;

  Color _background() {
    switch (variant) {
      case AppBadgeVariant.success:
        return AppColors.primaryContainer;
      case AppBadgeVariant.error:
        return AppColors.error;
      case AppBadgeVariant.info:
        return AppColors.secondary;
      case AppBadgeVariant.neutral:
        return AppColors.surfaceBright;
    }
  }

  Color _foreground() {
    switch (variant) {
      case AppBadgeVariant.success:
        return AppColors.onPrimaryContainer;
      case AppBadgeVariant.error:
        return AppColors.onError;
      case AppBadgeVariant.info:
        return AppColors.onSecondary;
      case AppBadgeVariant.neutral:
        return AppColors.onBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _background(),
        borderRadius: AppRadius.fullRadius,
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: _foreground()),
      ),
    );
  }
}
