import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../match_setup/domain/match_setup_data.dart';
import '../../domain/cricket_match_state.dart';

class LiveScoringScreen extends StatefulWidget {
  const LiveScoringScreen({
    required this.matchSetupData,
    super.key,
  });

  final MatchSetupData matchSetupData;

  @override
  State<LiveScoringScreen> createState() => _LiveScoringScreenState();
}

class _LiveScoringScreenState extends State<LiveScoringScreen> {
  late final CricketMatchController _match;

  late String _striker;
  late String _nonStriker;
  late String _currentBowler;

  late List<String> _currentBattingPlayers;
  late List<String> _currentBowlingPlayers;

  final Map<String, _BatterStats> _batterStats = <String, _BatterStats>{};

  final Map<String, _BowlerStats> _bowlerStats = <String, _BowlerStats>{};

  final Set<String> _dismissedBatters = <String>{};
  final List<_ScoringHistoryState> _history = <_ScoringHistoryState>[];

  @override
  void initState() {
    super.initState();

    _match = CricketMatchController(
      teamA: widget.matchSetupData.teamA,
      teamB: widget.matchSetupData.teamB,
      overs: widget.matchSetupData.overs,
      ballsPerOver: widget.matchSetupData.ballsPerOver,
      playersPerSide: widget.matchSetupData.playersPerSide,
      battingFirstTeam: widget.matchSetupData.battingTeam,
    );

    _currentBattingPlayers = List<String>.from(
      widget.matchSetupData.battingPlayers,
    );

    _currentBowlingPlayers = List<String>.from(
      widget.matchSetupData.bowlingPlayers,
    );

    _striker = widget.matchSetupData.striker ??
        _currentBattingPlayers.firstOrNull ??
        'Striker';

    _nonStriker = widget.matchSetupData.nonStriker ??
        _firstDifferentPlayer(
          players: _currentBattingPlayers,
          excludedPlayer: _striker,
          fallback: 'Non-Striker',
        );

    _currentBowler = widget.matchSetupData.openingBowler ??
        _currentBowlingPlayers.firstOrNull ??
        'Current Bowler';

    _ensureBatter(_striker);
    _ensureBatter(_nonStriker);
    _ensureBowler(_currentBowler);

    _syncControllerScorecards();
  }

  int get _ballsPerOver => widget.matchSetupData.ballsPerOver;

  _BatterStats _ensureBatter(String player) {
    return _batterStats.putIfAbsent(
      player,
      _BatterStats.new,
    );
  }

  _BowlerStats _ensureBowler(String player) {
    return _bowlerStats.putIfAbsent(
      player,
      _BowlerStats.new,
    );
  }

  String _firstDifferentPlayer({
    required List<String> players,
    required String excludedPlayer,
    required String fallback,
  }) {
    for (final String player in players) {
      if (player != excludedPlayer) {
        return player;
      }
    }

    return fallback;
  }

  void _swapStrike() {
    final String oldStriker = _striker;
    _striker = _nonStriker;
    _nonStriker = oldStriker;
  }

  CricketBallEvent _attachCurrentPlayers(
    CricketBallEvent event, {
    String? dismissedPlayer,
  }) {
    return event.copyWith(
      batterName: _striker,
      nonStrikerName: _nonStriker,
      bowlerName: _currentBowler,
      dismissedPlayerName: dismissedPlayer,
      batterRuns: _batterRunsForEvent(event),
    );
  }

  int _batterRunsForEvent(CricketBallEvent event) {
    switch (event.type) {
      case CricketEventType.run:
      case CricketEventType.four:
      case CricketEventType.six:
        return event.runs;

      case CricketEventType.dot:
      case CricketEventType.wide:
      case CricketEventType.noBall:
      case CricketEventType.bye:
      case CricketEventType.legBye:
      case CricketEventType.wicket:
        return 0;
    }
  }

  void _saveHistory() {
    _history.add(
      _ScoringHistoryState(
        striker: _striker,
        nonStriker: _nonStriker,
        bowler: _currentBowler,
        batterStats: _copyBatterStats(),
        bowlerStats: _copyBowlerStats(),
        dismissedBatters: Set<String>.from(
          _dismissedBatters,
        ),
      ),
    );
  }

  Map<String, _BatterStats> _copyBatterStats() {
    return _batterStats.map(
      (
        String player,
        _BatterStats statistics,
      ) {
        return MapEntry<String, _BatterStats>(
          player,
          statistics.copy(),
        );
      },
    );
  }

  Map<String, _BowlerStats> _copyBowlerStats() {
    return _bowlerStats.map(
      (
        String player,
        _BowlerStats statistics,
      ) {
        return MapEntry<String, _BowlerStats>(
          player,
          statistics.copy(),
        );
      },
    );
  }

  void _restoreHistory(_ScoringHistoryState state) {
    _striker = state.striker;
    _nonStriker = state.nonStriker;
    _currentBowler = state.bowler;

    _batterStats
      ..clear()
      ..addAll(
        state.batterStats.map(
          (
            String player,
            _BatterStats statistics,
          ) {
            return MapEntry<String, _BatterStats>(
              player,
              statistics.copy(),
            );
          },
        ),
      );

    _bowlerStats
      ..clear()
      ..addAll(
        state.bowlerStats.map(
          (
            String player,
            _BowlerStats statistics,
          ) {
            return MapEntry<String, _BowlerStats>(
              player,
              statistics.copy(),
            );
          },
        ),
      );

    _dismissedBatters
      ..clear()
      ..addAll(state.dismissedBatters);
  }

  void _syncControllerScorecards() {
    final List<BatterInningsSnapshot> battingScorecard =
        _batterStats.entries.map(
      (
        MapEntry<String, _BatterStats> entry,
      ) {
        final _BatterStats stats = entry.value;

        return BatterInningsSnapshot(
          playerName: entry.key,
          runs: stats.runs,
          balls: stats.balls,
          fours: stats.fours,
          sixes: stats.sixes,
          isOut: stats.isOut,
          dismissalText: stats.dismissalText,
        );
      },
    ).toList();

    final List<BowlerInningsSnapshot> bowlingScorecard =
        _bowlerStats.entries.map(
      (
        MapEntry<String, _BowlerStats> entry,
      ) {
        final _BowlerStats stats = entry.value;

        return BowlerInningsSnapshot(
          playerName: entry.key,
          legalBalls: stats.legalBalls,
          runs: stats.runs,
          wickets: stats.wickets,
          wides: stats.wides,
          noBalls: stats.noBalls,
          ballsPerOver: _ballsPerOver,
        );
      },
    ).toList();

    _match.updateCurrentScorecards(
      battingScorecard: battingScorecard,
      bowlingScorecard: bowlingScorecard,
    );
  }

  Future<void> _score(CricketBallEvent baseEvent) async {
    if (_match.isComplete) {
      return;
    }

    if (baseEvent.isWicket) {
      await _recordWicket();
      return;
    }

    final int previousInnings = _match.innings;
    final int previousLegalBalls = _match.legalBalls;

    final CricketBallEvent event = _attachCurrentPlayers(
      baseEvent,
    );

    _saveHistory();

    setState(() {
      _applyPlayerStatistics(event);
      _syncControllerScorecards();
      _match.addEvent(event);

      if (_shouldChangeStrike(event)) {
        _swapStrike();
      }
    });

    if (_match.isComplete) {
      await _showMatchCompleteSheet();
      return;
    }

    if (_match.innings != previousInnings) {
      await _prepareSecondInnings();
      return;
    }

    final bool overCompleted = event.isLegal &&
        previousLegalBalls < _match.legalBalls &&
        _match.legalBalls % _ballsPerOver == 0;

    if (overCompleted) {
      setState(_swapStrike);
      await _selectNextBowler();
    }
  }

  void _applyPlayerStatistics(CricketBallEvent event) {
    final _BatterStats batter = _ensureBatter(_striker);
    final _BowlerStats bowler = _ensureBowler(_currentBowler);

    if (event.isLegal) {
      batter.balls += 1;
      bowler.legalBalls += 1;
    }

    switch (event.type) {
      case CricketEventType.dot:
        break;

      case CricketEventType.run:
        batter.runs += event.runs;
        bowler.runs += event.runs;
        break;

      case CricketEventType.four:
        batter.runs += 4;
        batter.fours += 1;
        bowler.runs += 4;
        break;

      case CricketEventType.six:
        batter.runs += 6;
        batter.sixes += 1;
        bowler.runs += 6;
        break;

      case CricketEventType.wide:
        bowler.runs += event.runs;
        bowler.wides += event.runs;
        break;

      case CricketEventType.noBall:
        bowler.runs += event.runs;
        bowler.noBalls += event.runs;
        break;

      case CricketEventType.bye:
      case CricketEventType.legBye:
        break;

      case CricketEventType.wicket:
        batter.isOut = true;
        batter.dismissalText = 'b $_currentBowler';
        bowler.wickets += 1;
        break;
    }
  }

  bool _shouldChangeStrike(CricketBallEvent event) {
    switch (event.type) {
      case CricketEventType.run:
      case CricketEventType.bye:
      case CricketEventType.legBye:
        return event.runs.isOdd;

      case CricketEventType.dot:
      case CricketEventType.four:
      case CricketEventType.six:
      case CricketEventType.wide:
      case CricketEventType.noBall:
      case CricketEventType.wicket:
        return false;
    }
  }

  Future<void> _recordWicket() async {
    final List<String> availableBatters = _currentBattingPlayers.where(
      (String player) {
        return player != _striker &&
            player != _nonStriker &&
            !_dismissedBatters.contains(player);
      },
    ).toList();

    String? nextBatter;

    if (availableBatters.isNotEmpty) {
      nextBatter = await _showPlayerSelectionSheet(
        title: 'Select Next Batter',
        subtitle: 'Choose the next batter from ${_match.battingTeam}.',
        players: availableBatters,
        icon: Icons.sports_cricket_outlined,
        confirmLabel: 'Send Batter In',
      );

      if (nextBatter == null || !mounted) {
        return;
      }
    }

    final int previousInnings = _match.innings;
    final int previousLegalBalls = _match.legalBalls;
    final String dismissedPlayer = _striker;

    final CricketBallEvent wicketEvent = _attachCurrentPlayers(
      _wicket,
      dismissedPlayer: dismissedPlayer,
    );

    _saveHistory();

    setState(() {
      _applyPlayerStatistics(wicketEvent);
      _dismissedBatters.add(dismissedPlayer);

      _syncControllerScorecards();
      _match.addEvent(wicketEvent);

      if (_match.innings == previousInnings &&
          !_match.isComplete &&
          nextBatter != null) {
        _striker = nextBatter;
        _ensureBatter(_striker);
      }
    });

    if (_match.isComplete) {
      await _showMatchCompleteSheet();
      return;
    }

    if (_match.innings != previousInnings) {
      await _prepareSecondInnings();
      return;
    }

    if (nextBatter == null) {
      await _confirmEndInnings();
      return;
    }

    final bool overCompleted = previousLegalBalls < _match.legalBalls &&
        _match.legalBalls % _ballsPerOver == 0;

    if (overCompleted) {
      setState(_swapStrike);
      await _selectNextBowler();
    }
  }

  Future<void> _selectNextBowler() async {
    final List<String> availableBowlers = _currentBowlingPlayers
        .where(
          (String player) => player != _currentBowler,
        )
        .toList();

    if (availableBowlers.isEmpty) {
      return;
    }

    final String? selectedBowler = await _showPlayerSelectionSheet(
      title: 'Over Complete',
      subtitle: 'Select the next bowler from ${_match.bowlingTeam}.',
      players: availableBowlers,
      icon: Icons.sports_baseball_outlined,
      confirmLabel: 'Start Next Over',
      dismissible: false,
    );

    if (selectedBowler == null || !mounted) {
      return;
    }

    setState(() {
      _currentBowler = selectedBowler;
      _ensureBowler(_currentBowler);
      _syncControllerScorecards();
    });
  }

  Future<void> _prepareSecondInnings() async {
    _currentBattingPlayers = _match.battingTeam == widget.matchSetupData.teamA
        ? List<String>.from(
            widget.matchSetupData.teamAPlayers,
          )
        : List<String>.from(
            widget.matchSetupData.teamBPlayers,
          );

    _currentBowlingPlayers = _match.bowlingTeam == widget.matchSetupData.teamA
        ? List<String>.from(
            widget.matchSetupData.teamAPlayers,
          )
        : List<String>.from(
            widget.matchSetupData.teamBPlayers,
          );

    _dismissedBatters.clear();
    _history.clear();
    _batterStats.clear();
    _bowlerStats.clear();

    final String? striker = await _showPlayerSelectionSheet(
      title: 'Second Innings Striker',
      subtitle: 'Select the striker from ${_match.battingTeam}.',
      players: _currentBattingPlayers,
      icon: Icons.sports_cricket_outlined,
      confirmLabel: 'Select Striker',
      dismissible: false,
    );

    if (striker == null || !mounted) {
      return;
    }

    final List<String> nonStrikerOptions = _currentBattingPlayers
        .where(
          (String player) => player != striker,
        )
        .toList();

    final String? nonStriker = await _showPlayerSelectionSheet(
      title: 'Second Innings Non-Striker',
      subtitle: 'Select another batter from ${_match.battingTeam}.',
      players: nonStrikerOptions,
      icon: Icons.person_outline_rounded,
      confirmLabel: 'Select Non-Striker',
      dismissible: false,
    );

    if (nonStriker == null || !mounted) {
      return;
    }

    final String? bowler = await _showPlayerSelectionSheet(
      title: 'Second Innings Bowler',
      subtitle: 'Select the opening bowler from ${_match.bowlingTeam}.',
      players: _currentBowlingPlayers,
      icon: Icons.sports_baseball_outlined,
      confirmLabel: 'Start Chase',
      dismissible: false,
    );

    if (bowler == null || !mounted) {
      return;
    }

    setState(() {
      _striker = striker;
      _nonStriker = nonStriker;
      _currentBowler = bowler;

      _ensureBatter(_striker);
      _ensureBatter(_nonStriker);
      _ensureBowler(_currentBowler);
      _syncControllerScorecards();
    });

    await _showSecondInningsSheet();
  }

  Future<String?> _showPlayerSelectionSheet({
    required String title,
    required String subtitle,
    required List<String> players,
    required IconData icon,
    required String confirmLabel,
    bool dismissible = true,
  }) {
    String? selectedPlayer;

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      isDismissible: dismissible,
      enableDrag: dismissible,
      backgroundColor: AppColors.surfaceRaised,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            StateSetter sheetSetState,
          ) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.78,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.glassStroke,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Icon(
                        icon,
                        size: 38,
                        color: AppColors.primaryFixedDim,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: players.length,
                          separatorBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            return const SizedBox(
                              height: AppSpacing.sm,
                            );
                          },
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            final String player = players[index];

                            final bool selected = selectedPlayer == player;

                            return InkWell(
                              onTap: () {
                                sheetSetState(() {
                                  selectedPlayer = player;
                                });
                              },
                              borderRadius: AppRadius.smRadius,
                              child: AnimatedContainer(
                                duration: const Duration(
                                  milliseconds: 180,
                                ),
                                padding: const EdgeInsets.all(
                                  AppSpacing.md,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.primaryFixedDim
                                      : AppColors.surfaceBright,
                                  borderRadius: AppRadius.smRadius,
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.primaryFixedDim
                                        : AppColors.glassStroke,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      selected
                                          ? Icons.check_circle
                                          : Icons.person_outline,
                                      color: selected
                                          ? Colors.black
                                          : AppColors.primaryFixedDim,
                                    ),
                                    const SizedBox(
                                      width: AppSpacing.md,
                                    ),
                                    Expanded(
                                      child: Text(
                                        player,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: selected
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      PrimaryButton(
                        label: confirmLabel,
                        onPressed: selectedPlayer == null
                            ? null
                            : () {
                                Navigator.of(sheetContext).pop(
                                  selectedPlayer,
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showSecondInningsSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: AppColors.surfaceRaised,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.swap_horiz_rounded,
                  color: AppColors.primaryFixedDim,
                  size: 42,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Second Innings Ready',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${_match.battingTeam} need '
                  '${_match.runsRequired} runs from '
                  '${_match.totalBalls} balls.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '$_striker and $_nonStriker will open. '
                  '$_currentBowler will bowl first.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Start Chase',
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMatchCompleteSheet() {
    _syncControllerScorecards();

    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: AppColors.surfaceRaised,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events_outlined,
                  color: AppColors.primaryFixedDim,
                  size: 48,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Match Complete',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _match.winnerText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'View Match Summary',
                  onPressed: () {
                    Navigator.of(sheetContext).pop();

                    context.push(
                      '/match/demo/summary',
                      extra: _match.snapshot(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmEndInnings() async {
    final bool? shouldEnd = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            _match.innings == 1 ? 'End first innings?' : 'End match?',
          ),
          content: const Text(
            'Use this when the innings is declared '
            'or manually completed.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (shouldEnd != true || !mounted) {
      return;
    }

    final int previousInnings = _match.innings;

    _syncControllerScorecards();

    setState(_match.endInnings);

    if (_match.isComplete) {
      await _showMatchCompleteSheet();
    } else if (_match.innings != previousInnings) {
      await _prepareSecondInnings();
    }
  }

  void _undoLastEvent() {
    if (_match.events.isEmpty || _history.isEmpty) {
      return;
    }

    final _ScoringHistoryState previousState = _history.removeLast();

    setState(() {
      _match.undo();
      _restoreHistory(previousState);
      _syncControllerScorecards();
    });
  }

  void _openScorecard() {
    _syncControllerScorecards();

    context.push(
      '/match/demo/scorecard',
      extra: _match.snapshot(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LIVE SCORING'),
        actions: [
          IconButton(
            tooltip: 'Scorecard',
            onPressed: _openScorecard,
            icon: const Icon(
              Icons.table_chart_outlined,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LiveHeader(match: _match),
              const SizedBox(height: AppSpacing.md),
              _PlayersCard(
                striker: _striker,
                nonStriker: _nonStriker,
                bowler: _currentBowler,
                strikerStats: _ensureBatter(_striker),
                nonStrikerStats: _ensureBatter(_nonStriker),
                bowlerStats: _ensureBowler(_currentBowler),
                ballsPerOver: _ballsPerOver,
              ),
              const SizedBox(height: AppSpacing.md),
              _CurrentOver(events: _match.events),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Runs',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              LayoutBuilder(
                builder: (
                  BuildContext context,
                  BoxConstraints constraints,
                ) {
                  final int columns = constraints.maxWidth < 360 ? 3 : 4;

                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: constraints.maxWidth < 360 ? 1.35 : 1.55,
                    children: [
                      _ScoreButton(
                        label: '0',
                        onTap: () => _score(_dot),
                      ),
                      _ScoreButton(
                        label: '1',
                        onTap: () => _score(_run(1)),
                      ),
                      _ScoreButton(
                        label: '2',
                        onTap: () => _score(_run(2)),
                      ),
                      _ScoreButton(
                        label: '3',
                        onTap: () => _score(_run(3)),
                      ),
                      _ScoreButton(
                        label: '4',
                        onTap: () => _score(_four),
                      ),
                      _ScoreButton(
                        label: '6',
                        onTap: () => _score(_six),
                      ),
                      _ScoreButton(
                        label: 'W',
                        isDanger: true,
                        onTap: () => _score(_wicket),
                      ),
                      _ScoreButton(
                        label: 'Undo',
                        icon: Icons.undo,
                        onTap: _match.events.isEmpty ? null : _undoLastEvent,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Extras',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _ExtraChip(
                    label: 'Wide',
                    onTap: () => _score(_wide),
                  ),
                  _ExtraChip(
                    label: 'No Ball',
                    onTap: () => _score(_noBall),
                  ),
                  _ExtraChip(
                    label: 'Bye',
                    onTap: () => _score(_bye),
                  ),
                  _ExtraChip(
                    label: 'Leg Bye',
                    onTap: () => _score(_legBye),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: _match.canEndInnings ? _confirmEndInnings : null,
                icon: const Icon(Icons.flag_outlined),
                label: Text(
                  _match.innings == 1 ? 'End Innings' : 'End Match',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          if (index == 1) {
            _openScorecard();
          } else if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Match settings will be expanded '
                  'in Sprint 3.',
                ),
              ),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sports_cricket),
            label: 'Score',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            label: 'Scorecard',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _ScoringHistoryState {
  const _ScoringHistoryState({
    required this.striker,
    required this.nonStriker,
    required this.bowler,
    required this.batterStats,
    required this.bowlerStats,
    required this.dismissedBatters,
  });

  final String striker;
  final String nonStriker;
  final String bowler;

  final Map<String, _BatterStats> batterStats;
  final Map<String, _BowlerStats> bowlerStats;
  final Set<String> dismissedBatters;
}

class _BatterStats {
  int runs = 0;
  int balls = 0;
  int fours = 0;
  int sixes = 0;
  bool isOut = false;
  String dismissalText = '';

  _BatterStats copy() {
    return _BatterStats()
      ..runs = runs
      ..balls = balls
      ..fours = fours
      ..sixes = sixes
      ..isOut = isOut
      ..dismissalText = dismissalText;
  }
}

class _BowlerStats {
  int legalBalls = 0;
  int runs = 0;
  int wickets = 0;
  int wides = 0;
  int noBalls = 0;

  _BowlerStats copy() {
    return _BowlerStats()
      ..legalBalls = legalBalls
      ..runs = runs
      ..wickets = wickets
      ..wides = wides
      ..noBalls = noBalls;
  }

  String oversText(int ballsPerOver) {
    return '${legalBalls ~/ ballsPerOver}.'
        '${legalBalls % ballsPerOver}';
  }
}

class _PlayersCard extends StatelessWidget {
  const _PlayersCard({
    required this.striker,
    required this.nonStriker,
    required this.bowler,
    required this.strikerStats,
    required this.nonStrikerStats,
    required this.bowlerStats,
    required this.ballsPerOver,
  });

  final String striker;
  final String nonStriker;
  final String bowler;

  final _BatterStats strikerStats;
  final _BatterStats nonStrikerStats;
  final _BowlerStats bowlerStats;
  final int ballsPerOver;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(
          color: AppColors.glassStroke,
        ),
      ),
      child: Column(
        children: [
          _PlayerRow(
            name: striker,
            marker: '★',
            value: '${strikerStats.runs} '
                '(${strikerStats.balls})',
          ),
          const Divider(),
          _PlayerRow(
            name: nonStriker,
            marker: '',
            value: '${nonStrikerStats.runs} '
                '(${nonStrikerStats.balls})',
          ),
          const Divider(),
          _PlayerRow(
            name: bowler,
            marker: '○',
            value: '${bowlerStats.oversText(ballsPerOver)}–'
                '${bowlerStats.runs}–'
                '${bowlerStats.wickets}',
          ),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.name,
    required this.marker,
    required this.value,
  });

  final String name;
  final String marker;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Text(
              marker,
              style: const TextStyle(
                color: AppColors.primaryFixedDim,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

class _LiveHeader extends StatelessWidget {
  const _LiveHeader({
    required this.match,
  });

  final CricketMatchController match;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(
          color: AppColors.glassStroke,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(
                    alpha: 0.15,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  '● LIVE',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Innings ${match.innings} of 2',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            match.battingTeam,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${match.runs}/${match.wickets}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.primaryFixedDim,
                  fontWeight: FontWeight.w900,
                ),
          ),
          Text(
            '${match.oversText} / '
            '${match.overs} overs',
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'CRR',
                  value: match.currentRunRate.toStringAsFixed(2),
                ),
              ),
              if (match.innings == 2) ...[
                Expanded(
                  child: _Metric(
                    label: 'TARGET',
                    value: '${match.target}',
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: 'RRR',
                    value: match.requiredRunRate.toStringAsFixed(2),
                  ),
                ),
              ] else
                Expanded(
                  child: _Metric(
                    label: 'BALLS LEFT',
                    value: '${match.ballsRemaining}',
                  ),
                ),
            ],
          ),
          if (match.innings == 2) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              '${match.runsRequired} runs needed from '
              '${match.ballsRemaining} balls',
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _CurrentOver extends StatelessWidget {
  const _CurrentOver({
    required this.events,
  });

  final List<CricketBallEvent> events;

  @override
  Widget build(BuildContext context) {
    final List<CricketBallEvent> current =
        events.length <= 8 ? events : events.sublist(events.length - 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Over',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 44,
          child: current.isEmpty
              ? const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'No balls recorded yet',
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: current.length,
                  separatorBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return const SizedBox(
                      width: AppSpacing.sm,
                    );
                  },
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    final CricketBallEvent event = current[index];

                    return CircleAvatar(
                      backgroundColor: event.isWicket
                          ? Colors.redAccent.withValues(alpha: 0.18)
                          : AppColors.primaryFixedDim.withValues(alpha: 0.14),
                      foregroundColor: event.isWicket
                          ? Colors.redAccent
                          : AppColors.onBackground,
                      child: Text(
                        event.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ScoreButton extends StatelessWidget {
  const _ScoreButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDanger = false,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      key: Key('score_$label'),
      onPressed: onTap,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        backgroundColor: isDanger
            ? Colors.redAccent.withValues(
                alpha: 0.85,
              )
            : AppColors.surfaceRaised,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.smRadius,
          side: BorderSide(
            color: isDanger ? Colors.redAccent : AppColors.glassStroke,
          ),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: icon == null
            ? Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16),
                  const SizedBox(width: 3),
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ExtraChip extends StatelessWidget {
  const _ExtraChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      key: Key('extra_$label'),
      label: Text(label),
      onPressed: onTap,
      avatar: const Icon(
        Icons.add,
        size: 17,
      ),
    );
  }
}

const CricketBallEvent _dot = CricketBallEvent(
  label: '0',
  runs: 0,
  isLegal: true,
  isWicket: false,
  type: CricketEventType.dot,
);

CricketBallEvent _run(int runs) {
  return CricketBallEvent(
    label: '$runs',
    runs: runs,
    isLegal: true,
    isWicket: false,
    type: CricketEventType.run,
  );
}

const CricketBallEvent _four = CricketBallEvent(
  label: '4',
  runs: 4,
  isLegal: true,
  isWicket: false,
  type: CricketEventType.four,
);

const CricketBallEvent _six = CricketBallEvent(
  label: '6',
  runs: 6,
  isLegal: true,
  isWicket: false,
  type: CricketEventType.six,
);

const CricketBallEvent _wide = CricketBallEvent(
  label: 'Wd',
  runs: 1,
  isLegal: false,
  isWicket: false,
  type: CricketEventType.wide,
);

const CricketBallEvent _noBall = CricketBallEvent(
  label: 'Nb',
  runs: 1,
  isLegal: false,
  isWicket: false,
  type: CricketEventType.noBall,
);

const CricketBallEvent _bye = CricketBallEvent(
  label: 'B',
  runs: 1,
  isLegal: true,
  isWicket: false,
  type: CricketEventType.bye,
);

const CricketBallEvent _legBye = CricketBallEvent(
  label: 'Lb',
  runs: 1,
  isLegal: true,
  isWicket: false,
  type: CricketEventType.legBye,
);

const CricketBallEvent _wicket = CricketBallEvent(
  label: 'W',
  runs: 0,
  isLegal: true,
  isWicket: true,
  type: CricketEventType.wicket,
);

extension _FirstOrNullExtension<T> on List<T> {
  T? get firstOrNull {
    return isEmpty ? null : first;
  }
}
