import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportiq/features/cricket_scoring/domain/cricket_match_state.dart';
import 'package:sportiq/features/cricket_scoring/presentation/screens/live_scoring_screen.dart';
import 'package:sportiq/features/cricket_scoring/presentation/screens/match_summary_screen.dart';
import 'package:sportiq/features/match_setup/domain/match_setup_data.dart';
import 'package:sportiq/features/scorecard/presentation/screens/scorecard_screen.dart';
import 'package:sportiq/shared/theme/theme.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: child,
  );
}

void main() {
  test(
    'controller records legal balls, extras, wickets, and undo',
    () {
      final CricketMatchController controller = CricketMatchController(
        teamA: 'Falcons',
        teamB: 'Titans',
        overs: 2,
        ballsPerOver: 6,
        playersPerSide: 6,
        battingFirstTeam: 'Falcons',
      );

      controller.addEvent(
        const CricketBallEvent(
          label: '4',
          runs: 4,
          isLegal: true,
          isWicket: false,
          type: CricketEventType.four,
          batterName: 'Ali',
          nonStrikerName: 'Ahmed',
          bowlerName: 'Hamza',
          batterRuns: 4,
        ),
      );

      controller.addEvent(
        const CricketBallEvent(
          label: 'Wd',
          runs: 1,
          isLegal: false,
          isWicket: false,
          type: CricketEventType.wide,
          batterName: 'Ali',
          nonStrikerName: 'Ahmed',
          bowlerName: 'Hamza',
          batterRuns: 0,
        ),
      );

      controller.addEvent(
        const CricketBallEvent(
          label: 'W',
          runs: 0,
          isLegal: true,
          isWicket: true,
          type: CricketEventType.wicket,
          batterName: 'Ali',
          nonStrikerName: 'Ahmed',
          bowlerName: 'Hamza',
          dismissedPlayerName: 'Ali',
          batterRuns: 0,
        ),
      );

      expect(controller.runs, 5);
      expect(controller.legalBalls, 2);
      expect(controller.wickets, 1);

      controller.undo();

      expect(controller.wickets, 0);
      expect(controller.legalBalls, 1);
      expect(controller.runs, 5);
    },
  );

  test(
    'controller supports five-ball overs',
    () {
      final CricketMatchController controller = CricketMatchController(
        teamA: 'Falcons',
        teamB: 'Titans',
        overs: 2,
        ballsPerOver: 5,
        playersPerSide: 6,
      );

      for (int index = 0; index < 5; index++) {
        controller.addEvent(
          const CricketBallEvent(
            label: '0',
            runs: 0,
            isLegal: true,
            isWicket: false,
            type: CricketEventType.dot,
          ),
        );
      }

      expect(controller.legalBalls, 5);
      expect(controller.oversText, '1.0');
      expect(controller.ballsRemaining, 5);
    },
  );

  test(
    'controller starts chase and completes match at target',
    () {
      final CricketMatchController controller = CricketMatchController(
        teamA: 'Falcons',
        teamB: 'Titans',
        overs: 1,
        ballsPerOver: 6,
        playersPerSide: 6,
        battingFirstTeam: 'Falcons',
      );

      controller.addEvent(
        const CricketBallEvent(
          label: '6',
          runs: 6,
          isLegal: true,
          isWicket: false,
          type: CricketEventType.six,
        ),
      );

      controller.endInnings();

      expect(controller.innings, 2);
      expect(controller.target, 7);
      expect(controller.battingTeam, 'Titans');

      controller.addEvent(
        const CricketBallEvent(
          label: '6',
          runs: 6,
          isLegal: true,
          isWicket: false,
          type: CricketEventType.six,
        ),
      );

      controller.addEvent(
        const CricketBallEvent(
          label: '1',
          runs: 1,
          isLegal: true,
          isWicket: false,
          type: CricketEventType.run,
        ),
      );

      expect(controller.isComplete, isTrue);
      expect(controller.winnerText, contains('Titans won'));
    },
  );

  testWidgets(
    'live scoring screen renders selected players and scoring controls',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(900, 1400);
      tester.view.devicePixelRatio = 1;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const MatchSetupData matchSetupData = MatchSetupData(
        teamA: 'Falcons',
        teamB: 'Titans',
        teamAPlayers: <String>[
          'Ali',
          'Ahmed',
          'Usman',
        ],
        teamBPlayers: <String>[
          'Hamza',
          'Bilal',
          'Saad',
        ],
        overs: 5,
        playersPerSide: 3,
        ballsPerOver: 6,
        tossWinner: 'Falcons',
        decision: 'Bat',
        striker: 'Ali',
        nonStriker: 'Ahmed',
        openingBowler: 'Hamza',
      );

      await tester.pumpWidget(
        _wrap(
          const LiveScoringScreen(
            matchSetupData: matchSetupData,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('LIVE SCORING'), findsOneWidget);
      expect(find.text('Falcons'), findsOneWidget);
      expect(find.text('Ali'), findsOneWidget);
      expect(find.text('Ahmed'), findsOneWidget);
      expect(find.text('Hamza'), findsOneWidget);

      expect(
        find.byKey(const Key('score_4')),
        findsOneWidget,
      );

      expect(
        find.byKey(const Key('score_W')),
        findsOneWidget,
      );

      expect(
        find.byKey(const Key('extra_Wide')),
        findsOneWidget,
      );

      final Finder scoreFourButton = find.byKey(
        const Key('score_4'),
      );

      await tester.ensureVisible(scoreFourButton);
      await tester.pumpAndSettle();

      await tester.tap(scoreFourButton);
      await tester.pumpAndSettle();

      expect(find.text('4/0'), findsOneWidget);
      expect(find.text('0.1 / 5 overs'), findsOneWidget);
      expect(find.text('4 (1)'), findsOneWidget);
    },
  );

  testWidgets(
    'scorecard renders actual player statistics',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(900, 2000);
      tester.view.devicePixelRatio = 1;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const CricketMatchSnapshot snapshot = CricketMatchSnapshot(
        teamA: 'Falcons',
        teamB: 'Titans',
        overs: 5,
        ballsPerOver: 6,
        playersPerSide: 3,
        currentInnings: 1,
        firstInnings: null,
        secondInnings: InningsSnapshot(
          battingTeam: 'Falcons',
          bowlingTeam: 'Titans',
          runs: 12,
          wickets: 1,
          legalBalls: 6,
          ballsPerOver: 6,
          events: <CricketBallEvent>[
            CricketBallEvent(
              label: '4',
              runs: 4,
              isLegal: true,
              isWicket: false,
              type: CricketEventType.four,
              batterName: 'Ali',
              nonStrikerName: 'Ahmed',
              bowlerName: 'Hamza',
              batterRuns: 4,
            ),
          ],
          battingScorecard: <BatterInningsSnapshot>[
            BatterInningsSnapshot(
              playerName: 'Ali',
              runs: 8,
              balls: 4,
              fours: 2,
              sixes: 0,
              isOut: true,
              dismissalText: 'b Hamza',
            ),
            BatterInningsSnapshot(
              playerName: 'Ahmed',
              runs: 4,
              balls: 2,
              fours: 1,
              sixes: 0,
              isOut: false,
            ),
          ],
          bowlingScorecard: <BowlerInningsSnapshot>[
            BowlerInningsSnapshot(
              playerName: 'Hamza',
              legalBalls: 6,
              runs: 12,
              wickets: 1,
              wides: 0,
              noBalls: 0,
              ballsPerOver: 6,
            ),
          ],
        ),
        isComplete: false,
        winnerText: '',
      );

      await tester.pumpWidget(
        _wrap(
          const ScorecardScreen(
            snapshot: snapshot,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('SCORECARD'), findsOneWidget);
      expect(find.text('Batting'), findsOneWidget);
      expect(find.text('Bowling'), findsOneWidget);
      expect(find.text('12/1'), findsOneWidget);
      expect(find.textContaining('Ali'), findsOneWidget);
      expect(find.textContaining('Ahmed'), findsOneWidget);
      expect(find.text('Hamza'), findsOneWidget);
    },
  );

  testWidgets(
    'match summary renders winner and innings scores',
    (WidgetTester tester) async {
      const CricketMatchSnapshot snapshot = CricketMatchSnapshot(
        teamA: 'Falcons',
        teamB: 'Titans',
        overs: 5,
        ballsPerOver: 6,
        playersPerSide: 6,
        currentInnings: 2,
        firstInnings: InningsSnapshot(
          battingTeam: 'Falcons',
          bowlingTeam: 'Titans',
          runs: 30,
          wickets: 2,
          legalBalls: 30,
          ballsPerOver: 6,
          events: <CricketBallEvent>[],
        ),
        secondInnings: InningsSnapshot(
          battingTeam: 'Titans',
          bowlingTeam: 'Falcons',
          runs: 31,
          wickets: 3,
          legalBalls: 24,
          ballsPerOver: 6,
          events: <CricketBallEvent>[],
        ),
        isComplete: true,
        winnerText: 'Titans won by 3 wickets',
      );

      await tester.pumpWidget(
        _wrap(
          const MatchSummaryScreen(
            snapshot: snapshot,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Titans won by 3 wickets'),
        findsOneWidget,
      );

      expect(find.text('30/2'), findsOneWidget);
      expect(find.text('31/3'), findsOneWidget);
    },
  );
}
