import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/match_setup_data.dart';
import '../widgets/setup_scaffold.dart';

class TossSetupScreen extends StatefulWidget {
  const TossSetupScreen({
    required this.matchSetupData,
    super.key,
  });

  final MatchSetupData matchSetupData;

  @override
  State<TossSetupScreen> createState() => _TossSetupScreenState();
}

class _TossSetupScreenState extends State<TossSetupScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _coinAnimationController;
  late final Animation<double> _coinRotationAnimation;
  late final Animation<double> _coinScaleAnimation;

  String? _winner;
  String _decision = 'Bat';
  bool _isFlipping = false;

  @override
  void initState() {
    super.initState();

    _winner = widget.matchSetupData.tossWinner;
    _decision = widget.matchSetupData.decision ?? 'Bat';

    _coinAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1500,
      ),
    );

    _coinRotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi * 10,
    ).animate(
      CurvedAnimation(
        parent: _coinAnimationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _coinScaleAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 1,
            end: 1.16,
          ).chain(
            CurveTween(
              curve: Curves.easeOut,
            ),
          ),
          weight: 25,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 1.16,
            end: 0.92,
          ).chain(
            CurveTween(
              curve: Curves.easeInOut,
            ),
          ),
          weight: 35,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 0.92,
            end: 1,
          ).chain(
            CurveTween(
              curve: Curves.elasticOut,
            ),
          ),
          weight: 40,
        ),
      ],
    ).animate(
      _coinAnimationController,
    );
  }

  @override
  void dispose() {
    _coinAnimationController.dispose();
    super.dispose();
  }

  String get _otherTeam {
    if (_winner == widget.matchSetupData.teamA) {
      return widget.matchSetupData.teamB;
    }

    return widget.matchSetupData.teamA;
  }

  String? get _battingTeam {
    if (_winner == null) {
      return null;
    }

    if (_decision == 'Bat') {
      return _winner;
    }

    return _otherTeam;
  }

  String? get _bowlingTeam {
    if (_battingTeam == null) {
      return null;
    }

    if (_battingTeam == widget.matchSetupData.teamA) {
      return widget.matchSetupData.teamB;
    }

    return widget.matchSetupData.teamA;
  }

  Future<void> _flipCoin() async {
    if (_isFlipping) {
      return;
    }

    setState(() {
      _isFlipping = true;
      _winner = null;
    });

    await _coinAnimationController.forward(
      from: 0,
    );

    if (!mounted) {
      return;
    }

    final bool teamAWins = math.Random().nextBool();

    setState(() {
      _winner =
          teamAWins ? widget.matchSetupData.teamA : widget.matchSetupData.teamB;
      _isFlipping = false;
    });
  }

  void _continueToReview() {
    if (_winner == null) {
      return;
    }

    final MatchSetupData updatedData = widget.matchSetupData.copyWith(
      tossWinner: _winner,
      decision: _decision,
      clearStriker: true,
      clearNonStriker: true,
      clearOpeningBowler: true,
    );

    context.push(
      AppRoutes.cricketReady,
      extra: updatedData,
    );
  }

  Widget _buildCoin() {
    return AnimatedBuilder(
      animation: _coinAnimationController,
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        final double rotation = _coinRotationAnimation.value;
        final double scale = _coinScaleAnimation.value;

        final Matrix4 transform = Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..rotateY(rotation)
          ..rotateX(rotation * 0.18)
          ..scaleByDouble(
            scale,
            scale,
            scale,
            1,
          );

        return Transform(
          alignment: Alignment.center,
          transform: transform,
          child: child,
        );
      },
      child: Container(
        width: 170,
        height: 170,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: _winner == null
                ? <Color>[
                    AppColors.surfaceBright,
                    AppColors.surfaceRaised,
                  ]
                : <Color>[
                    AppColors.primaryFixedDim,
                    AppColors.primaryFixedDim.withValues(
                      alpha: 0.72,
                    ),
                  ],
          ),
          border: Border.all(
            color: AppColors.primaryFixedDim,
            width: 3,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primaryFixedDim.withValues(
                alpha: _isFlipping ? 0.34 : 0.18,
              ),
              blurRadius: _isFlipping ? 46 : 30,
              spreadRadius: _isFlipping ? 7 : 2,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _winner == null
                      ? AppColors.glassStroke
                      : AppColors.onPrimaryFixed.withValues(
                          alpha: 0.34,
                        ),
                ),
              ),
            ),
            if (_isFlipping)
              const Icon(
                Icons.sports_cricket,
                size: 62,
                color: AppColors.primaryFixedDim,
              )
            else if (_winner == null)
              const Icon(
                Icons.casino_outlined,
                size: 62,
                color: AppColors.primaryFixedDim,
              )
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    size: 50,
                    color: AppColors.onPrimaryFixed,
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: Text(
                      _winner!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.onPrimaryFixed,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultText() {
    if (_isFlipping) {
      return Column(
        children: [
          Text(
            'Coin in the air...',
            key: const Key(
              'tossResult',
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryFixedDim,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Let the digital coin decide.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }

    if (_winner == null) {
      return Column(
        children: [
          Text(
            'Ready to flip',
            key: const Key(
              'tossResult',
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap below to start the toss.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }

    return Column(
      children: [
        Text(
          '$_winner won the toss',
          key: const Key(
            'tossResult',
          ),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primaryFixedDim,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Now choose whether they will bat or bowl first.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildDecisionSection() {
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 320,
      ),
      child: _winner == null
          ? const SizedBox.shrink()
          : Container(
              key: ValueKey<String>(
                _winner!,
              ),
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
                  Text(
                    'Winning Team Decision',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'What did $_winner choose?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SegmentedButton<String>(
                    segments: const <ButtonSegment<String>>[
                      ButtonSegment<String>(
                        value: 'Bat',
                        icon: Icon(
                          Icons.sports_cricket_outlined,
                        ),
                        label: Text(
                          'Bat First',
                        ),
                      ),
                      ButtonSegment<String>(
                        value: 'Bowl',
                        icon: Icon(
                          Icons.sports_baseball_outlined,
                        ),
                        label: Text(
                          'Bowl First',
                        ),
                      ),
                    ],
                    selected: <String>{
                      _decision,
                    },
                    onSelectionChanged: (Set<String> selection) {
                      setState(() {
                        _decision = selection.first;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _TeamRolePreview(
                    battingTeam: _battingTeam!,
                    bowlingTeam: _bowlingTeam!,
                  ),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SetupScaffold(
      step: 'Step 4 of 5',
      title: 'Toss Setup',
      subtitle: 'Flip the SPORTIQ coin and choose the winning team’s decision.',
      bottom: PrimaryButton(
        label: 'Review Match',
        onPressed: _winner == null || _isFlipping ? null : _continueToReview,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          Center(
            child: _buildCoin(),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildResultText(),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: _winner == null ? 'Flip Coin' : 'Flip Again',
            isLoading: _isFlipping,
            onPressed: _flipCoin,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildDecisionSection(),
        ],
      ),
    );
  }
}

class _TeamRolePreview extends StatelessWidget {
  const _TeamRolePreview({
    required this.battingTeam,
    required this.bowlingTeam,
  });

  final String battingTeam;
  final String bowlingTeam;

  Widget _buildRoleCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String teamName,
  }) {
    return Expanded(
      child: Container(
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
          children: [
            Icon(
              icon,
              color: AppColors.primaryFixedDim,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primaryFixedDim,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              teamName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildRoleCard(
          context: context,
          icon: Icons.sports_cricket_outlined,
          label: 'BATTING FIRST',
          teamName: battingTeam,
        ),
        const SizedBox(width: AppSpacing.sm),
        _buildRoleCard(
          context: context,
          icon: Icons.sports_baseball_outlined,
          label: 'BOWLING FIRST',
          teamName: bowlingTeam,
        ),
      ],
    );
  }
}
