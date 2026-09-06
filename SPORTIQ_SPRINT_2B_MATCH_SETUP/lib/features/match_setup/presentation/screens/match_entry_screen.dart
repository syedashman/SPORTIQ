import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../widgets/setup_scaffold.dart';

class MatchEntryScreen extends StatelessWidget {
  const MatchEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SetupScaffold(
      step: 'Cricket selected',
      title: 'Ready for the next match?',
      subtitle: 'Create a new match or join one using a match code.',
      child: Column(
        children: [
          _EntryCard(
            icon: Icons.add_circle_outline,
            title: 'Create Match',
            subtitle: 'Set up teams, players, overs and the toss.',
            onTap: () => context.push(AppRoutes.createTeams),
          ),
          const SizedBox(height: AppSpacing.md),
          _EntryCard(
            icon: Icons.qr_code_scanner,
            title: 'Join Match',
            subtitle: 'Enter a match code or scan a venue QR.',
            onTap: () => _showJoinSheet(context),
          ),
        ],
      ),
    );
  }

  void _showJoinSheet(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceRaised,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Join a Match', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Enter the six-character code shared by the organizer.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: controller,
              textCapitalization: TextCapitalization.characters,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'Match Code'),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Join Match',
              onPressed: () {
                Navigator.pop(sheetContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Match joining will connect to the backend later.',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: AppColors.glassStroke),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primaryFixedDim.withValues(alpha: 0.12),
                borderRadius: AppRadius.smRadius,
              ),
              child: Icon(icon, color: AppColors.primaryFixedDim),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
