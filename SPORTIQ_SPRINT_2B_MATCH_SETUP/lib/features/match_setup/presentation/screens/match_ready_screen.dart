import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/match_setup_data.dart';
import '../widgets/setup_scaffold.dart';

class MatchReadyScreen extends StatelessWidget {
  const MatchReadyScreen({
    required this.matchSetupData,
    super.key,
  });

  final MatchSetupData matchSetupData;

  void _startMatch(BuildContext context) {
    context.push(
      AppRoutes.cricketOpeningPlayers,
      extra: matchSetupData.copyWith(
        clearStriker: true,
        clearNonStriker: true,
        clearOpeningBowler: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SetupScaffold(
      step: 'Step 5 of 5',
      title: 'Review Match',
      subtitle:
          'Everything is set. Review the match before selecting the opening players.',
      bottom: PrimaryButton(
        label: 'Start Match',
        icon: Icons.play_arrow_rounded,
        onPressed: () => _startMatch(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MatchHeaderCard(
            teamA: matchSetupData.teamA,
            teamB: matchSetupData.teamB,
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: 'Match Format',
            icon: Icons.tune_rounded,
            children: [
              _SummaryRow(
                label: 'Overs',
                value: '${matchSetupData.overs}',
              ),
              _SummaryRow(
                label: 'Players per side',
                value: '${matchSetupData.playersPerSide}',
              ),
              _SummaryRow(
                label: 'Balls per over',
                value: '${matchSetupData.ballsPerOver}',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: 'Toss Result',
            icon: Icons.emoji_events_rounded,
            children: [
              _SummaryRow(
                label: 'Toss winner',
                value: matchSetupData.tossWinner ?? 'Not set',
              ),
              _SummaryRow(
                label: 'Decision',
                value: '${matchSetupData.decision ?? 'Not set'} first',
              ),
              _SummaryRow(
                label: 'Batting first',
                value: matchSetupData.battingTeam,
                highlight: true,
              ),
              _SummaryRow(
                label: 'Bowling first',
                value: matchSetupData.bowlingTeam,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: 'Team Lineups',
            icon: Icons.groups_2_rounded,
            children: [
              _TeamLineupPreview(
                teamName: matchSetupData.teamA,
                players: matchSetupData.teamAPlayers,
              ),
              const SizedBox(height: AppSpacing.md),
              _TeamLineupPreview(
                teamName: matchSetupData.teamB,
                players: matchSetupData.teamBPlayers,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(
              AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryFixedDim.withValues(
                alpha: 0.08,
              ),
              borderRadius: AppRadius.smRadius,
              border: Border.all(
                color: AppColors.primaryFixedDim.withValues(
                  alpha: 0.28,
                ),
              ),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primaryFixedDim,
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'After starting the match, choose the striker and non-striker from the batting team and the opening bowler from the bowling team.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchHeaderCard extends StatelessWidget {
  const _MatchHeaderCard({
    required this.teamA,
    required this.teamB,
  });

  final String teamA;
  final String teamB;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.surfaceRaised,
            AppColors.surfaceBright,
          ],
        ),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(
          color: AppColors.primaryFixedDim.withValues(
            alpha: 0.34,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryFixedDim.withValues(
              alpha: 0.08,
            ),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.sports_cricket_rounded,
            color: AppColors.primaryFixedDim,
            size: 46,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            teamA,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'VS',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primaryFixedDim,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            teamB,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(
          color: AppColors.glassStroke,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primaryFixedDim,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: highlight ? AppColors.primaryFixedDim : Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamLineupPreview extends StatelessWidget {
  const _TeamLineupPreview({
    required this.teamName,
    required this.players,
  });

  final String teamName;
  final List<String> players;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: AppRadius.smRadius,
        border: Border.all(
          color: AppColors.glassStroke,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  teamName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixedDim.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                ),
                child: Text(
                  '${players.length} players',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primaryFixedDim,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: players
                .map(
                  (String player) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceRaised,
                      borderRadius: BorderRadius.circular(
                        100,
                      ),
                    ),
                    child: Text(
                      player,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
