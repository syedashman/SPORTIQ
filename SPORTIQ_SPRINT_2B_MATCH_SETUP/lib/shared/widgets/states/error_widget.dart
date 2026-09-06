// Reusable error state per DESIGN_RULES.md, with retry action.
import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../buttons/primary_button.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    this.title = 'Something went wrong',
    this.message,
    this.onRetry,
    super.key,
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: 'Retry', onPressed: onRetry!),
            ],
          ],
        ),
      ),
    );
  }
}
