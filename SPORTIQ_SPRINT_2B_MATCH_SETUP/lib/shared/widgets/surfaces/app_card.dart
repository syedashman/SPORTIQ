// Standard card surface — styled via CardTheme (surface-raised + glass
// stroke border, per DESIGN_SYSTEM.md).
import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdRadius,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
