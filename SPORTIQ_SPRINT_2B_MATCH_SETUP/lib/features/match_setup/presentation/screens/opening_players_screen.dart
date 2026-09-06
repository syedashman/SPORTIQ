import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/match_setup_data.dart';
import '../widgets/setup_scaffold.dart';

class OpeningPlayersScreen extends StatefulWidget {
  const OpeningPlayersScreen({
    required this.matchSetupData,
    super.key,
  });

  final MatchSetupData matchSetupData;

  @override
  State<OpeningPlayersScreen> createState() => _OpeningPlayersScreenState();
}

class _OpeningPlayersScreenState extends State<OpeningPlayersScreen> {
  String? _striker;
  String? _nonStriker;
  String? _openingBowler;

  List<String> get _battingPlayers {
    return widget.matchSetupData.battingPlayers;
  }

  List<String> get _bowlingPlayers {
    return widget.matchSetupData.bowlingPlayers;
  }

  bool get _canStartScoring {
    return _striker != null &&
        _nonStriker != null &&
        _openingBowler != null &&
        _striker != _nonStriker;
  }

  List<String> get _availableNonStrikers {
    return _battingPlayers
        .where(
          (String player) => player != _striker,
        )
        .toList();
  }

  void _startScoring() {
    if (!_canStartScoring) {
      return;
    }

    final MatchSetupData updatedData = widget.matchSetupData.copyWith(
      striker: _striker,
      nonStriker: _nonStriker,
      openingBowler: _openingBowler,
    );

    context.push(
      AppRoutes.cricketLiveScoring,
      extra: updatedData,
    );
  }

  void _selectStriker(String playerName) {
    setState(() {
      _striker = playerName;

      if (_nonStriker == playerName) {
        _nonStriker = null;
      }
    });
  }

  void _selectNonStriker(String playerName) {
    setState(() {
      _nonStriker = playerName;
    });
  }

  void _selectOpeningBowler(String playerName) {
    setState(() {
      _openingBowler = playerName;
    });
  }

  Widget _buildSelectionSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> players,
    required String? selectedPlayer,
    required ValueChanged<String> onSelected,
    required String selectionKeyPrefix,
  }) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.surfaceBright,
                  borderRadius: AppRadius.smRadius,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryFixedDim,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...players.map(
            (String playerName) {
              final bool isSelected = selectedPlayer == playerName;

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.sm,
                ),
                child: InkWell(
                  key: Key(
                    '${selectionKeyPrefix}_$playerName',
                  ),
                  onTap: () => onSelected(playerName),
                  borderRadius: AppRadius.smRadius,
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 180,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryFixedDim
                          : AppColors.surfaceBright,
                      borderRadius: AppRadius.smRadius,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryFixedDim
                            : AppColors.glassStroke,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 19,
                          backgroundColor: isSelected
                              ? Colors.black.withValues(
                                  alpha: 0.14,
                                )
                              : AppColors.surfaceRaised,
                          child: Icon(
                            isSelected
                                ? Icons.check_rounded
                                : Icons.person_outline_rounded,
                            size: 20,
                            color: isSelected
                                ? Colors.black
                                : AppColors.primaryFixedDim,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            playerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color:
                                      isSelected ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.black,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMatchRolesPreview() {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryFixedDim.withValues(
          alpha: 0.08,
        ),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(
          color: AppColors.primaryFixedDim.withValues(
            alpha: 0.25,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sports_cricket_rounded,
                color: AppColors.primaryFixedDim,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Opening Players',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _RoleSummaryRow(
            label: 'Batting team',
            value: widget.matchSetupData.battingTeam,
          ),
          _RoleSummaryRow(
            label: 'Bowling team',
            value: widget.matchSetupData.bowlingTeam,
          ),
          _RoleSummaryRow(
            label: 'Striker',
            value: _striker ?? 'Not selected',
            highlight: _striker != null,
          ),
          _RoleSummaryRow(
            label: 'Non-striker',
            value: _nonStriker ?? 'Not selected',
            highlight: _nonStriker != null,
          ),
          _RoleSummaryRow(
            label: 'Opening bowler',
            value: _openingBowler ?? 'Not selected',
            highlight: _openingBowler != null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SetupScaffold(
      step: 'Opening Players',
      title: 'Select Opening Players',
      subtitle:
          'Choose two batters from ${widget.matchSetupData.battingTeam} and one bowler from ${widget.matchSetupData.bowlingTeam}.',
      bottom: PrimaryButton(
        label: 'Start Scoring',
        icon: Icons.play_arrow_rounded,
        onPressed: _canStartScoring ? _startScoring : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMatchRolesPreview(),
          const SizedBox(height: AppSpacing.md),
          _buildSelectionSection(
            title: 'Select Striker',
            subtitle: 'Choose the batter who will face the first delivery.',
            icon: Icons.sports_cricket_outlined,
            players: _battingPlayers,
            selectedPlayer: _striker,
            onSelected: _selectStriker,
            selectionKeyPrefix: 'striker',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSelectionSection(
            title: 'Select Non-Striker',
            subtitle: 'Choose the second opening batter from the same team.',
            icon: Icons.person_outline_rounded,
            players: _availableNonStrikers,
            selectedPlayer: _nonStriker,
            onSelected: _selectNonStriker,
            selectionKeyPrefix: 'nonStriker',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSelectionSection(
            title: 'Select Opening Bowler',
            subtitle:
                'Choose the first bowler from ${widget.matchSetupData.bowlingTeam}.',
            icon: Icons.sports_baseball_outlined,
            players: _bowlingPlayers,
            selectedPlayer: _openingBowler,
            onSelected: _selectOpeningBowler,
            selectionKeyPrefix: 'bowler',
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(
              AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: AppRadius.smRadius,
              border: Border.all(
                color: AppColors.glassStroke,
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
                    'The striker and non-striker must be different players. The bowler is always selected from the opposing team.',
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

class _RoleSummaryRow extends StatelessWidget {
  const _RoleSummaryRow({
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
        vertical: AppSpacing.xs,
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
