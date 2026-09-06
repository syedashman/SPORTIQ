import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/cricket_match_state.dart';

class MatchSummaryScreen extends StatelessWidget {
  const MatchSummaryScreen({required this.snapshot, super.key});

  final CricketMatchSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MATCH SUMMARY')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.emoji_events_outlined,
                color: AppColors.primaryFixedDim,
                size: 64,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                snapshot.winnerText.isEmpty
                    ? 'Match in progress'
                    : snapshot.winnerText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xl),
              if (snapshot.firstInnings != null)
                _InningsSummary(innings: snapshot.firstInnings!),
              const SizedBox(height: AppSpacing.md),
              _InningsSummary(innings: snapshot.secondInnings),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: AppRadius.mdRadius,
                  border: Border.all(color: AppColors.glassStroke),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryFixedDim,
                      foregroundColor: Colors.black,
                      child: Icon(Icons.star_outline),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Player of the Match'),
                          Text(
                            'Selection available after player profiles are connected',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'View Full Scorecard',
                onPressed: () =>
                    context.push('/match/demo/scorecard', extra: snapshot),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () => context.go('/choose-sport'),
                child: const Text('Back to Sports'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InningsSummary extends StatelessWidget {
  const _InningsSummary({required this.innings});

  final InningsSnapshot innings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: AppColors.glassStroke),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  innings.battingTeam,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text('${innings.oversText} overs'),
              ],
            ),
          ),
          Text(
            '${innings.runs}/${innings.wickets}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryFixedDim,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}
