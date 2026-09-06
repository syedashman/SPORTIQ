import 'dart:math' as math;

enum CricketEventType {
  dot,
  run,
  four,
  six,
  wide,
  noBall,
  bye,
  legBye,
  wicket,
}

class CricketBallEvent {
  const CricketBallEvent({
    required this.label,
    required this.runs,
    required this.isLegal,
    required this.isWicket,
    required this.type,
    this.batterName,
    this.nonStrikerName,
    this.bowlerName,
    this.dismissedPlayerName,
    this.batterRuns,
  });

  final String label;
  final int runs;
  final bool isLegal;
  final bool isWicket;
  final CricketEventType type;

  final String? batterName;
  final String? nonStrikerName;
  final String? bowlerName;
  final String? dismissedPlayerName;

  /// Runs credited specifically to the batter.
  ///
  /// For byes, leg-byes, wides and the no-ball penalty this can be zero,
  /// even though the team total increases.
  final int? batterRuns;

  CricketBallEvent copyWith({
    String? label,
    int? runs,
    bool? isLegal,
    bool? isWicket,
    CricketEventType? type,
    String? batterName,
    String? nonStrikerName,
    String? bowlerName,
    String? dismissedPlayerName,
    int? batterRuns,
  }) {
    return CricketBallEvent(
      label: label ?? this.label,
      runs: runs ?? this.runs,
      isLegal: isLegal ?? this.isLegal,
      isWicket: isWicket ?? this.isWicket,
      type: type ?? this.type,
      batterName: batterName ?? this.batterName,
      nonStrikerName: nonStrikerName ?? this.nonStrikerName,
      bowlerName: bowlerName ?? this.bowlerName,
      dismissedPlayerName: dismissedPlayerName ?? this.dismissedPlayerName,
      batterRuns: batterRuns ?? this.batterRuns,
    );
  }
}

class BatterInningsSnapshot {
  const BatterInningsSnapshot({
    required this.playerName,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.isOut,
    this.dismissalText = '',
  });

  final String playerName;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final bool isOut;
  final String dismissalText;

  double get strikeRate {
    if (balls == 0) {
      return 0;
    }

    return runs * 100 / balls;
  }
}

class BowlerInningsSnapshot {
  const BowlerInningsSnapshot({
    required this.playerName,
    required this.legalBalls,
    required this.runs,
    required this.wickets,
    this.wides = 0,
    this.noBalls = 0,
    this.ballsPerOver = 6,
  });

  final String playerName;
  final int legalBalls;
  final int runs;
  final int wickets;
  final int wides;
  final int noBalls;
  final int ballsPerOver;

  String get oversText {
    return '${legalBalls ~/ ballsPerOver}.${legalBalls % ballsPerOver}';
  }

  double get economy {
    if (legalBalls == 0) {
      return 0;
    }

    return runs * ballsPerOver / legalBalls;
  }
}

class InningsSnapshot {
  const InningsSnapshot({
    required this.battingTeam,
    required this.bowlingTeam,
    required this.runs,
    required this.wickets,
    required this.legalBalls,
    required this.events,
    this.ballsPerOver = 6,
    this.battingScorecard = const <BatterInningsSnapshot>[],
    this.bowlingScorecard = const <BowlerInningsSnapshot>[],
  });

  final String battingTeam;
  final String bowlingTeam;
  final int runs;
  final int wickets;
  final int legalBalls;
  final int ballsPerOver;

  final List<CricketBallEvent> events;
  final List<BatterInningsSnapshot> battingScorecard;
  final List<BowlerInningsSnapshot> bowlingScorecard;

  String get oversText {
    return '${legalBalls ~/ ballsPerOver}.${legalBalls % ballsPerOver}';
  }

  double get runRate {
    if (legalBalls == 0) {
      return 0;
    }

    return runs * ballsPerOver / legalBalls;
  }

  int get fours {
    return events
        .where(
          (CricketBallEvent event) => event.type == CricketEventType.four,
        )
        .length;
  }

  int get sixes {
    return events
        .where(
          (CricketBallEvent event) => event.type == CricketEventType.six,
        )
        .length;
  }

  int get extras {
    return events.where(
      (CricketBallEvent event) {
        return event.type == CricketEventType.wide ||
            event.type == CricketEventType.noBall ||
            event.type == CricketEventType.bye ||
            event.type == CricketEventType.legBye;
      },
    ).fold<int>(
      0,
      (
        int total,
        CricketBallEvent event,
      ) {
        return total + event.runs;
      },
    );
  }
}

class CricketMatchSnapshot {
  const CricketMatchSnapshot({
    required this.teamA,
    required this.teamB,
    required this.overs,
    required this.currentInnings,
    required this.firstInnings,
    required this.secondInnings,
    required this.isComplete,
    required this.winnerText,
    this.ballsPerOver = 6,
    this.playersPerSide = 11,
  });

  final String teamA;
  final String teamB;

  final int overs;
  final int ballsPerOver;
  final int playersPerSide;

  final int currentInnings;
  final InningsSnapshot? firstInnings;
  final InningsSnapshot secondInnings;

  final bool isComplete;
  final String winnerText;
}

class CricketMatchController {
  CricketMatchController({
    required this.teamA,
    required this.teamB,
    required this.overs,
    this.ballsPerOver = 6,
    this.playersPerSide = 11,
    String? battingFirstTeam,
  })  : battingTeam = battingFirstTeam ?? teamA,
        bowlingTeam = (battingFirstTeam ?? teamA) == teamA ? teamB : teamA;

  final String teamA;
  final String teamB;

  final int overs;
  final int ballsPerOver;
  final int playersPerSide;

  int innings = 1;

  String battingTeam;
  String bowlingTeam;

  int runs = 0;
  int wickets = 0;
  int legalBalls = 0;

  InningsSnapshot? firstInnings;

  final List<CricketBallEvent> events = <CricketBallEvent>[];

  List<BatterInningsSnapshot> _currentBattingScorecard =
      const <BatterInningsSnapshot>[];

  List<BowlerInningsSnapshot> _currentBowlingScorecard =
      const <BowlerInningsSnapshot>[];

  bool isComplete = false;
  String winnerText = '';

  int get totalBalls => overs * ballsPerOver;

  int get maximumWickets {
    return math.max(
      1,
      playersPerSide - 1,
    );
  }

  int get ballsRemaining {
    return math.max(
      0,
      totalBalls - legalBalls,
    );
  }

  int? get target {
    if (firstInnings == null) {
      return null;
    }

    return firstInnings!.runs + 1;
  }

  int get runsRequired {
    if (target == null) {
      return 0;
    }

    return math.max(
      0,
      target! - runs,
    );
  }

  String get oversText {
    return '${legalBalls ~/ ballsPerOver}.${legalBalls % ballsPerOver}';
  }

  double get currentRunRate {
    if (legalBalls == 0) {
      return 0;
    }

    return runs * ballsPerOver / legalBalls;
  }

  double get requiredRunRate {
    if (innings != 2 || ballsRemaining == 0 || runsRequired == 0) {
      return 0;
    }

    return runsRequired * ballsPerOver / ballsRemaining;
  }

  bool get canEndInnings {
    return events.isNotEmpty && !isComplete;
  }

  void updateCurrentScorecards({
    required List<BatterInningsSnapshot> battingScorecard,
    required List<BowlerInningsSnapshot> bowlingScorecard,
  }) {
    _currentBattingScorecard = List<BatterInningsSnapshot>.unmodifiable(
      battingScorecard,
    );

    _currentBowlingScorecard = List<BowlerInningsSnapshot>.unmodifiable(
      bowlingScorecard,
    );
  }

  void addEvent(CricketBallEvent event) {
    if (isComplete) {
      return;
    }

    events.add(event);
    runs += event.runs;

    if (event.isWicket) {
      wickets += 1;
    }

    if (event.isLegal) {
      legalBalls += 1;
    }

    _evaluateInnings();
  }

  void undo() {
    if (events.isEmpty) {
      return;
    }

    if (isComplete) {
      isComplete = false;
      winnerText = '';
    }

    final CricketBallEvent event = events.removeLast();

    runs = math.max(
      0,
      runs - event.runs,
    );

    if (event.isWicket) {
      wickets = math.max(
        0,
        wickets - 1,
      );
    }

    if (event.isLegal) {
      legalBalls = math.max(
        0,
        legalBalls - 1,
      );
    }
  }

  void endInnings() {
    if (isComplete) {
      return;
    }

    if (innings == 1) {
      _startSecondInnings();
    } else {
      _completeMatch();
    }
  }

  void _evaluateInnings() {
    if (innings == 2 && target != null && runs >= target!) {
      _completeMatch();
      return;
    }

    final bool allOut = wickets >= maximumWickets;
    final bool oversComplete = legalBalls >= totalBalls;

    if (!allOut && !oversComplete) {
      return;
    }

    if (innings == 1) {
      _startSecondInnings();
    } else {
      _completeMatch();
    }
  }

  void _startSecondInnings() {
    firstInnings = _currentSnapshot();

    innings = 2;

    final String previousBattingTeam = battingTeam;

    battingTeam = bowlingTeam;
    bowlingTeam = previousBattingTeam;

    runs = 0;
    wickets = 0;
    legalBalls = 0;

    events.clear();

    _currentBattingScorecard = const <BatterInningsSnapshot>[];

    _currentBowlingScorecard = const <BowlerInningsSnapshot>[];
  }

  void _completeMatch() {
    isComplete = true;

    final int firstRuns = firstInnings?.runs ?? 0;

    if (runs > firstRuns) {
      final int wicketsRemaining = math.max(
        0,
        playersPerSide - wickets,
      );

      winnerText = '$battingTeam won by $wicketsRemaining wickets';
      return;
    }

    if (runs < firstRuns) {
      winnerText = '$bowlingTeam won by ${firstRuns - runs} runs';
      return;
    }

    winnerText = 'Match tied';
  }

  InningsSnapshot _currentSnapshot() {
    return InningsSnapshot(
      battingTeam: battingTeam,
      bowlingTeam: bowlingTeam,
      runs: runs,
      wickets: wickets,
      legalBalls: legalBalls,
      ballsPerOver: ballsPerOver,
      events: List<CricketBallEvent>.unmodifiable(
        events,
      ),
      battingScorecard: List<BatterInningsSnapshot>.unmodifiable(
        _currentBattingScorecard,
      ),
      bowlingScorecard: List<BowlerInningsSnapshot>.unmodifiable(
        _currentBowlingScorecard,
      ),
    );
  }

  CricketMatchSnapshot snapshot() {
    return CricketMatchSnapshot(
      teamA: teamA,
      teamB: teamB,
      overs: overs,
      ballsPerOver: ballsPerOver,
      playersPerSide: playersPerSide,
      currentInnings: innings,
      firstInnings: firstInnings,
      secondInnings: _currentSnapshot(),
      isComplete: isComplete,
      winnerText: winnerText,
    );
  }
}
