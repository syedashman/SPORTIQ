// Choose Your Sport screen (Stitch ref: choose_your_sport_2).
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../app/app_router.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';

enum _Sport { cricket, football, padel }

class _SportOption {
  const _SportOption({
    required this.sport,
    required this.icon,
    required this.title,
    required this.description,
  });

  final _Sport sport;
  final IconData icon;
  final String title;
  final String description;
}

const List<_SportOption> _sports = [
  _SportOption(
    sport: _Sport.cricket,
    icon: Icons.sports_cricket,
    title: 'Cricket',
    description: 'Score every ball, over and innings.',
  ),
  _SportOption(
    sport: _Sport.football,
    icon: Icons.sports_soccer,
    title: 'Football',
    description: 'Track goals, cards, time and substitutions.',
  ),
  _SportOption(
    sport: _Sport.padel,
    icon: Icons.sports_tennis,
    title: 'Padel',
    description: 'Track points, games, sets and tie-breaks.',
  ),
];

class ChooseSportScreen extends StatefulWidget {
  const ChooseSportScreen({super.key});

  @override
  State<ChooseSportScreen> createState() => _ChooseSportScreenState();
}

class _ChooseSportScreenState extends State<ChooseSportScreen> {
  _Sport? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'SPORTIQ',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primaryFixedDim,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'What are you playing today?',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Choose your sport and start your match in seconds.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView.separated(
                  itemCount: _sports.length,
                  separatorBuilder: (context, i) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, i) {
                    final option = _sports[i];
                    return _SportCard(
                      option: option,
                      selected: _selected == option.sport,
                      onTap: () => setState(() => _selected = option.sport),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: 'Continue',
                onPressed: _selected == null
                    ? null
                    : () {
                        if (_selected == _Sport.cricket) {
                          context.push(AppRoutes.matchEntry);
                          return;
                        }
                        context.push(
                          _selected == _Sport.football
                              ? '/football/match'
                              : '/padel/match',
                        );
                      },
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'Choose Later',
                onPressed: () => context.push('/dashboard'),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _SportCard extends StatelessWidget {
  const _SportCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _SportOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceBright : AppColors.surfaceRaised,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(
            color: selected ? AppColors.primaryFixedDim : AppColors.glassStroke,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(option.icon, color: AppColors.primaryFixedDim, size: 32),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    option.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: AppColors.primaryFixedDim)
            else
              const Icon(
                Icons.arrow_forward,
                color: AppColors.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
