import 'package:flutter/material.dart';

import '../../../../features/cricket_scoring/domain/cricket_match_state.dart';
import '../../../../shared/theme/theme.dart';

class ScorecardScreen extends StatelessWidget {
  const ScorecardScreen({
    required this.snapshot,
    super.key,
  });

  final CricketMatchSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final List<InningsSnapshot> inningsList = <InningsSnapshot>[
      if (snapshot.firstInnings != null) snapshot.firstInnings!,
      snapshot.secondInnings,
    ];

    return DefaultTabController(
      length: inningsList.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SCORECARD'),
          bottom: TabBar(
            isScrollable: inningsList.length > 2,
            tabs: <Widget>[
              for (int index = 0; index < inningsList.length; index++)
                Tab(
                  text: index == 0 ? '1st Innings' : '2nd Innings',
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            for (final InningsSnapshot innings in inningsList)
              _InningsScorecard(
                innings: innings,
              ),
          ],
        ),
      ),
    );
  }
}

class _InningsScorecard extends StatelessWidget {
  const _InningsScorecard({
    required this.innings,
  });

  final InningsSnapshot innings;

  List<BatterInningsSnapshot> get _battingRows {
    if (innings.battingScorecard.isNotEmpty) {
      return innings.battingScorecard;
    }

    return _buildBattingFallback();
  }

  List<BowlerInningsSnapshot> get _bowlingRows {
    if (innings.bowlingScorecard.isNotEmpty) {
      return innings.bowlingScorecard;
    }

    return _buildBowlingFallback();
  }

  List<BatterInningsSnapshot> _buildBattingFallback() {
    final Map<String, _MutableBatterStats> stats =
        <String, _MutableBatterStats>{};

    for (final CricketBallEvent event in innings.events) {
      final String? batterName = event.batterName;

      if (batterName == null || batterName.trim().isEmpty) {
        continue;
      }

      final _MutableBatterStats batter = stats.putIfAbsent(
        batterName,
        () => _MutableBatterStats(
          playerName: batterName,
        ),
      );

      if (event.isLegal) {
        batter.balls += 1;
      }

      final int batterRuns = event.batterRuns ?? _eventBatterRuns(event);

      batter.runs += batterRuns;

      if (event.type == CricketEventType.four) {
        batter.fours += 1;
      }

      if (event.type == CricketEventType.six) {
        batter.sixes += 1;
      }

      if (event.isWicket && event.dismissedPlayerName == batterName) {
        batter.isOut = true;
        batter.dismissalText =
            event.bowlerName == null ? 'out' : 'b ${event.bowlerName}';
      }
    }

    if (stats.isEmpty) {
      return const <BatterInningsSnapshot>[];
    }

    return stats.values
        .map(
          (_MutableBatterStats batter) => BatterInningsSnapshot(
            playerName: batter.playerName,
            runs: batter.runs,
            balls: batter.balls,
            fours: batter.fours,
            sixes: batter.sixes,
            isOut: batter.isOut,
            dismissalText: batter.dismissalText,
          ),
        )
        .toList();
  }

  List<BowlerInningsSnapshot> _buildBowlingFallback() {
    final Map<String, _MutableBowlerStats> stats =
        <String, _MutableBowlerStats>{};

    for (final CricketBallEvent event in innings.events) {
      final String? bowlerName = event.bowlerName;

      if (bowlerName == null || bowlerName.trim().isEmpty) {
        continue;
      }

      final _MutableBowlerStats bowler = stats.putIfAbsent(
        bowlerName,
        () => _MutableBowlerStats(
          playerName: bowlerName,
        ),
      );

      if (event.isLegal) {
        bowler.legalBalls += 1;
      }

      switch (event.type) {
        case CricketEventType.dot:
        case CricketEventType.run:
        case CricketEventType.four:
        case CricketEventType.six:
          bowler.runs += event.runs;

        case CricketEventType.wide:
          bowler.runs += event.runs;
          bowler.wides += event.runs;

        case CricketEventType.noBall:
          bowler.runs += event.runs;
          bowler.noBalls += event.runs;

        case CricketEventType.wicket:
          bowler.wickets += 1;

        case CricketEventType.bye:
        case CricketEventType.legBye:
          break;
      }
    }

    if (stats.isEmpty) {
      return const <BowlerInningsSnapshot>[];
    }

    return stats.values
        .map(
          (_MutableBowlerStats bowler) => BowlerInningsSnapshot(
            playerName: bowler.playerName,
            legalBalls: bowler.legalBalls,
            runs: bowler.runs,
            wickets: bowler.wickets,
            wides: bowler.wides,
            noBalls: bowler.noBalls,
            ballsPerOver: innings.ballsPerOver,
          ),
        )
        .toList();
  }

  int _eventBatterRuns(CricketBallEvent event) {
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

  @override
  Widget build(BuildContext context) {
    final List<BatterInningsSnapshot> battingRows = _battingRows;
    final List<BowlerInningsSnapshot> bowlingRows = _bowlingRows;

    return ListView(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      children: <Widget>[
        _InningsHeader(
          innings: innings,
        ),
        const SizedBox(height: AppSpacing.md),
        const _SectionTitle(
          title: 'Batting',
        ),
        if (battingRows.isEmpty)
          const _EmptyScorecardMessage(
            message: 'No batter statistics recorded yet.',
          )
        else
          _BattingTable(
            batters: battingRows,
          ),
        const SizedBox(height: AppSpacing.md),
        const _SectionTitle(
          title: 'Bowling',
        ),
        if (bowlingRows.isEmpty)
          const _EmptyScorecardMessage(
            message: 'No bowler statistics recorded yet.',
          )
        else
          _BowlingTable(
            bowlers: bowlingRows,
          ),
        const SizedBox(height: AppSpacing.md),
        const _SectionTitle(
          title: 'Innings Details',
        ),
        _DetailsCard(
          innings: innings,
        ),
        const SizedBox(height: AppSpacing.md),
        const _SectionTitle(
          title: 'Ball by Ball',
        ),
        _BallByBallSection(
          events: innings.events,
        ),
      ],
    );
  }
}

class _InningsHeader extends StatelessWidget {
  const _InningsHeader({
    required this.innings,
  });

  final InningsSnapshot innings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(
          color: AppColors.glassStroke,
        ),
      ),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.sports_cricket_rounded,
            size: 38,
            color: AppColors.primaryFixedDim,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            innings.battingTeam,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${innings.runs}/${innings.wickets}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.primaryFixedDim,
                  fontWeight: FontWeight.w900,
                ),
          ),
          Text(
            '${innings.oversText} overs',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _BattingTable extends StatelessWidget {
  const _BattingTable({
    required this.batters,
  });

  final List<BatterInningsSnapshot> batters;

  @override
  Widget build(BuildContext context) {
    return _ScrollableScoreTable(
      minimumWidth: 680,
      headerCells: const <_TableCellData>[
        _TableCellData(
          text: 'Batter',
          width: 210,
          alignment: Alignment.centerLeft,
        ),
        _TableCellData(text: 'R', width: 58),
        _TableCellData(text: 'B', width: 58),
        _TableCellData(text: '4s', width: 58),
        _TableCellData(text: '6s', width: 58),
        _TableCellData(text: 'SR', width: 80),
      ],
      rows: batters.map(
        (BatterInningsSnapshot batter) {
          final String status = batter.isOut
              ? batter.dismissalText.isEmpty
                  ? 'out'
                  : batter.dismissalText
              : 'not out';

          return <_TableCellData>[
            _TableCellData(
              text: '${batter.playerName}\n$status',
              width: 210,
              alignment: Alignment.centerLeft,
              highlight: !batter.isOut,
            ),
            _TableCellData(
              text: '${batter.runs}',
              width: 58,
            ),
            _TableCellData(
              text: '${batter.balls}',
              width: 58,
            ),
            _TableCellData(
              text: '${batter.fours}',
              width: 58,
            ),
            _TableCellData(
              text: '${batter.sixes}',
              width: 58,
            ),
            _TableCellData(
              text: batter.strikeRate.toStringAsFixed(1),
              width: 80,
            ),
          ];
        },
      ).toList(),
    );
  }
}

class _BowlingTable extends StatelessWidget {
  const _BowlingTable({
    required this.bowlers,
  });

  final List<BowlerInningsSnapshot> bowlers;

  @override
  Widget build(BuildContext context) {
    return _ScrollableScoreTable(
      minimumWidth: 690,
      headerCells: const <_TableCellData>[
        _TableCellData(
          text: 'Bowler',
          width: 200,
          alignment: Alignment.centerLeft,
        ),
        _TableCellData(text: 'O', width: 65),
        _TableCellData(text: 'R', width: 58),
        _TableCellData(text: 'W', width: 58),
        _TableCellData(text: 'WD', width: 58),
        _TableCellData(text: 'NB', width: 58),
        _TableCellData(text: 'Econ', width: 80),
      ],
      rows: bowlers.map(
        (BowlerInningsSnapshot bowler) {
          return <_TableCellData>[
            _TableCellData(
              text: bowler.playerName,
              width: 200,
              alignment: Alignment.centerLeft,
            ),
            _TableCellData(
              text: bowler.oversText,
              width: 65,
            ),
            _TableCellData(
              text: '${bowler.runs}',
              width: 58,
            ),
            _TableCellData(
              text: '${bowler.wickets}',
              width: 58,
              highlight: bowler.wickets > 0,
            ),
            _TableCellData(
              text: '${bowler.wides}',
              width: 58,
            ),
            _TableCellData(
              text: '${bowler.noBalls}',
              width: 58,
            ),
            _TableCellData(
              text: bowler.economy.toStringAsFixed(2),
              width: 80,
            ),
          ];
        },
      ).toList(),
    );
  }
}

class _ScrollableScoreTable extends StatelessWidget {
  const _ScrollableScoreTable({
    required this.minimumWidth,
    required this.headerCells,
    required this.rows,
  });

  final double minimumWidth;
  final List<_TableCellData> headerCells;
  final List<List<_TableCellData>> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadius.smRadius,
        border: Border.all(
          color: AppColors.glassStroke,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minimumWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: AppColors.surfaceBright,
                child: Row(
                  children: headerCells.map(
                    (_TableCellData cell) {
                      return _ScoreTableCell(
                        cell: cell,
                        isHeader: true,
                      );
                    },
                  ).toList(),
                ),
              ),
              for (int index = 0; index < rows.length; index++) ...[
                if (index > 0)
                  const Divider(
                    height: 1,
                  ),
                Row(
                  children: rows[index].map(
                    (_TableCellData cell) {
                      return _ScoreTableCell(
                        cell: cell,
                      );
                    },
                  ).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreTableCell extends StatelessWidget {
  const _ScoreTableCell({
    required this.cell,
    this.isHeader = false,
  });

  final _TableCellData cell;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cell.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        child: Align(
          alignment: cell.alignment,
          child: Text(
            cell.text,
            maxLines: cell.text.contains('\n') ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            textAlign: cell.alignment == Alignment.centerLeft
                ? TextAlign.left
                : TextAlign.center,
            style: isHeader
                ? Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    )
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cell.highlight
                          ? AppColors.primaryFixedDim
                          : Colors.white,
                      fontWeight:
                          cell.highlight ? FontWeight.w800 : FontWeight.w500,
                    ),
          ),
        ),
      ),
    );
  }
}

class _TableCellData {
  const _TableCellData({
    required this.text,
    required this.width,
    this.alignment = Alignment.center,
    this.highlight = false,
  });

  final String text;
  final double width;
  final Alignment alignment;
  final bool highlight;
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    required this.innings,
  });

  final InningsSnapshot innings;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: <Widget>[
          _DetailRow(
            label: 'Extras',
            value: '${innings.extras}',
          ),
          _DetailRow(
            label: 'Boundaries',
            value: '${innings.fours} fours, ${innings.sixes} sixes',
          ),
          _DetailRow(
            label: 'Run Rate',
            value: innings.runRate.toStringAsFixed(2),
          ),
          _DetailRow(
            label: 'Balls per over',
            value: '${innings.ballsPerOver}',
          ),
          _DetailRow(
            label: 'Bowling Team',
            value: innings.bowlingTeam,
          ),
        ],
      ),
    );
  }
}

class _BallByBallSection extends StatelessWidget {
  const _BallByBallSection({
    required this.events,
  });

  final List<CricketBallEvent> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const _EmptyScorecardMessage(
        message: 'No events recorded yet.',
      );
    }

    return Container(
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
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: events.map(
          (CricketBallEvent event) {
            return Tooltip(
              message: _eventDescription(event),
              child: Chip(
                avatar: event.isWicket
                    ? const Icon(
                        Icons.close_rounded,
                        size: 17,
                        color: Colors.redAccent,
                      )
                    : null,
                label: Text(
                  event.label,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  String _eventDescription(CricketBallEvent event) {
    final String batter = event.batterName ?? 'Batter';
    final String bowler = event.bowlerName ?? 'Bowler';

    if (event.isWicket) {
      return '$batter dismissed by $bowler';
    }

    return '$bowler to $batter: ${event.label}';
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyScorecardMessage extends StatelessWidget {
  const _EmptyScorecardMessage({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _MutableBatterStats {
  _MutableBatterStats({
    required this.playerName,
  });

  final String playerName;

  int runs = 0;
  int balls = 0;
  int fours = 0;
  int sixes = 0;

  bool isOut = false;
  String dismissalText = '';
}

class _MutableBowlerStats {
  _MutableBowlerStats({
    required this.playerName,
  });

  final String playerName;

  int legalBalls = 0;
  int runs = 0;
  int wickets = 0;
  int wides = 0;
  int noBalls = 0;
}
