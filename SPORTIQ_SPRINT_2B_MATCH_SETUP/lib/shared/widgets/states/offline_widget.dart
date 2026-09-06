// Reusable offline banner/state per DESIGN_RULES.md.
import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class OfflineWidget extends StatelessWidget {
  const OfflineWidget({this.onRetry, super.key});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: AppColors.surfaceBright,
      child: Row(
        children: [
          const Icon(Icons.wifi_off, size: 18, color: AppColors.onBackground),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'You are offline',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
