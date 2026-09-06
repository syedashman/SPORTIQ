import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

class SetupScaffold extends StatelessWidget {
  const SetupScaffold({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.child,
    this.bottom,
    super.key,
  });

  final String step;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SPORTIQ'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        step.toUpperCase(),
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.primaryFixedDim,
                                  letterSpacing: 1.5,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      child,
                    ],
                  ),
                ),
              ),
            ),
            if (bottom != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceBase,
                  border: Border(top: BorderSide(color: AppColors.glassStroke)),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: bottom,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
