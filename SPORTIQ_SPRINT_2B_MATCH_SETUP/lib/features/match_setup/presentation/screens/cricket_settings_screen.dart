import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/match_setup_data.dart';
import '../widgets/setup_scaffold.dart';

class CricketSettingsScreen extends StatefulWidget {
  const CricketSettingsScreen({
    required this.matchSetupData,
    super.key,
  });

  final MatchSetupData matchSetupData;

  @override
  State<CricketSettingsScreen> createState() => _CricketSettingsScreenState();
}

class _CricketSettingsScreenState extends State<CricketSettingsScreen> {
  late int _overs;
  late int _playersPerSide;
  late int _ballsPerOver;

  @override
  void initState() {
    super.initState();

    _overs = widget.matchSetupData.overs;
    _playersPerSide = _getInitialPlayersPerSide();
    _ballsPerOver = widget.matchSetupData.ballsPerOver;
  }

  int get _maximumAvailablePlayers {
    final int teamACount = widget.matchSetupData.teamAPlayers.length;
    final int teamBCount = widget.matchSetupData.teamBPlayers.length;

    return teamACount < teamBCount ? teamACount : teamBCount;
  }

  int _getInitialPlayersPerSide() {
    final int maximumPlayers = _maximumAvailablePlayers;
    final int configuredPlayers = widget.matchSetupData.playersPerSide;

    if (maximumPlayers < 2) {
      return 2;
    }

    if (configuredPlayers > maximumPlayers) {
      return maximumPlayers;
    }

    if (configuredPlayers < 2) {
      return 2;
    }

    return configuredPlayers;
  }

  List<int> get _availablePlayerCounts {
    final int maximumPlayers = _maximumAvailablePlayers;

    if (maximumPlayers < 2) {
      return const <int>[2];
    }

    return List<int>.generate(
      maximumPlayers - 1,
      (int index) => index + 2,
    );
  }

  void _changeOvers(int delta) {
    setState(() {
      _overs = (_overs + delta).clamp(1, 50);
    });
  }

  void _continueToToss() {
    final MatchSetupData updatedData = widget.matchSetupData.copyWith(
      overs: _overs,
      playersPerSide: _playersPerSide,
      ballsPerOver: _ballsPerOver,
      clearTossWinner: true,
      clearDecision: true,
      clearStriker: true,
      clearNonStriker: true,
      clearOpeningBowler: true,
    );

    context.push(
      AppRoutes.cricketToss,
      extra: updatedData,
    );
  }

  Widget _buildOversControl() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: const Key('decreaseOvers'),
          tooltip: 'Decrease overs',
          onPressed: _overs > 1 ? () => _changeOvers(-1) : null,
          icon: const Icon(
            Icons.remove_circle_outline,
          ),
        ),
        Container(
          constraints: const BoxConstraints(
            minWidth: 42,
          ),
          alignment: Alignment.center,
          child: Text(
            '$_overs',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryFixedDim,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        IconButton(
          key: const Key('increaseOvers'),
          tooltip: 'Increase overs',
          onPressed: _overs < 50 ? () => _changeOvers(1) : null,
          icon: const Icon(
            Icons.add_circle_outline,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersControl() {
    return DropdownButton<int>(
      value: _playersPerSide,
      underline: const SizedBox.shrink(),
      borderRadius: AppRadius.smRadius,
      items: _availablePlayerCounts
          .map(
            (int value) => DropdownMenuItem<int>(
              value: value,
              child: Text(
                '$value',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (int? value) {
        if (value == null) {
          return;
        }

        setState(() {
          _playersPerSide = value;
        });
      },
    );
  }

  Widget _buildBallsPerOverControl() {
    return SegmentedButton<int>(
      segments: const <ButtonSegment<int>>[
        ButtonSegment<int>(
          value: 5,
          label: Text('5'),
        ),
        ButtonSegment<int>(
          value: 6,
          label: Text('6'),
        ),
      ],
      selected: <int>{
        _ballsPerOver,
      },
      onSelectionChanged: (Set<int> selection) {
        setState(() {
          _ballsPerOver = selection.first;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SetupScaffold(
      step: 'Step 3 of 5',
      title: 'Match Settings',
      subtitle:
          'Set the format for ${widget.matchSetupData.teamA} vs ${widget.matchSetupData.teamB}.',
      bottom: PrimaryButton(
        label: 'Continue to Toss',
        onPressed: _continueToToss,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SettingCard(
            icon: Icons.sports_cricket_outlined,
            title: 'Overs',
            subtitle: 'Total overs per innings',
            trailing: _buildOversControl(),
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingCard(
            icon: Icons.groups_2_outlined,
            title: 'Players per side',
            subtitle: 'Choose from the players already added to both teams',
            trailing: _buildPlayersControl(),
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingCard(
            icon: Icons.sports_baseball_outlined,
            title: 'Balls per over',
            subtitle: 'Indoor formats may use five or six balls',
            trailing: _buildBallsPerOverControl(),
          ),
          const SizedBox(height: AppSpacing.lg),
          _MatchFormatPreview(
            teamA: widget.matchSetupData.teamA,
            teamB: widget.matchSetupData.teamB,
            overs: _overs,
            playersPerSide: _playersPerSide,
            ballsPerOver: _ballsPerOver,
          ),
        ],
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

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
      child: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          final bool useVerticalLayout = constraints.maxWidth < 430;

          final Widget information = Row(
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
          );

          if (useVerticalLayout) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                information,
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: trailing,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: information,
              ),
              const SizedBox(width: AppSpacing.md),
              trailing,
            ],
          );
        },
      ),
    );
  }
}

class _MatchFormatPreview extends StatelessWidget {
  const _MatchFormatPreview({
    required this.teamA,
    required this.teamB,
    required this.overs,
    required this.playersPerSide,
    required this.ballsPerOver,
  });

  final String teamA;
  final String teamB;
  final int overs;
  final int playersPerSide;
  final int ballsPerOver;

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
          color: AppColors.primaryFixedDim,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.fact_check_outlined,
                color: AppColors.primaryFixedDim,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Match Format Preview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '$teamA vs $teamB',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryFixedDim,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _PreviewChip(
                icon: Icons.sports_cricket_outlined,
                label: '$overs overs',
              ),
              _PreviewChip(
                icon: Icons.groups_2_outlined,
                label: '$playersPerSide players',
              ),
              _PreviewChip(
                icon: Icons.sports_baseball_outlined,
                label: '$ballsPerOver balls',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: AppRadius.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 17,
            color: AppColors.primaryFixedDim,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
