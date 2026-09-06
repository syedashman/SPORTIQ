import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportiq/features/match_setup/domain/match_setup_data.dart';
import 'package:sportiq/features/match_setup/presentation/screens/add_players_screen.dart';
import 'package:sportiq/features/match_setup/presentation/screens/create_teams_screen.dart';
import 'package:sportiq/features/match_setup/presentation/screens/cricket_settings_screen.dart';
import 'package:sportiq/features/match_setup/presentation/screens/match_entry_screen.dart';
import 'package:sportiq/features/match_setup/presentation/screens/match_ready_screen.dart';
import 'package:sportiq/features/match_setup/presentation/screens/opening_players_screen.dart';
import 'package:sportiq/features/match_setup/presentation/screens/toss_setup_screen.dart';
import 'package:sportiq/shared/theme/theme.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: child,
  );
}

const MatchSetupData _baseMatchSetupData = MatchSetupData(
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
);

const MatchSetupData _tossCompletedData = MatchSetupData(
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
);

void main() {
  testWidgets(
    'Match entry shows create and join actions',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          const MatchEntryScreen(),
        ),
      );

      expect(
        find.text('Create Match'),
        findsOneWidget,
      );

      expect(
        find.text('Join Match'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Create teams validates and renders both team fields',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          const CreateTeamsScreen(),
        ),
      );

      expect(
        find.text('Home Team'),
        findsOneWidget,
      );

      expect(
        find.text('Away Team'),
        findsOneWidget,
      );

      expect(
        find.text('Add Players'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Add players renders both teams and opens player sheet',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(
        900,
        1400,
      );

      tester.view.devicePixelRatio = 1;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _wrap(
          const AddPlayersScreen(
            teamA: 'Falcons',
            teamB: 'Titans',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Falcons Captain'),
        findsOneWidget,
      );

      expect(
        find.text('Titans'),
        findsWidgets,
      );

      final Finder addPlayerButton = find.byKey(
        const Key('addPlayerButton'),
      );

      expect(
        addPlayerButton,
        findsOneWidget,
      );

      await tester.ensureVisible(
        addPlayerButton,
      );

      await tester.tap(
        addPlayerButton,
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Add Temporary Player'),
        findsOneWidget,
      );

      expect(
        find.text('Invite with Link'),
        findsOneWidget,
      );

      expect(
        find.text('Add Existing Player'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Cricket settings shows overs and match format controls',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(
        900,
        1400,
      );

      tester.view.devicePixelRatio = 1;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _wrap(
          const CricketSettingsScreen(
            matchSetupData: _baseMatchSetupData,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Overs'),
        findsOneWidget,
      );

      expect(
        find.text('Players per side'),
        findsOneWidget,
      );

      expect(
        find.text('Balls per over'),
        findsOneWidget,
      );

      expect(
        find.text('Match Format Preview'),
        findsOneWidget,
      );

      expect(
        find.text('Falcons vs Titans'),
        findsOneWidget,
      );

      expect(
        find.text('5 overs'),
        findsOneWidget,
      );

      expect(
        find.text('3 players'),
        findsOneWidget,
      );

      expect(
        find.text('6 balls'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Toss screen starts with animated flip action',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(
        900,
        1400,
      );

      tester.view.devicePixelRatio = 1;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _wrap(
          const TossSetupScreen(
            matchSetupData: _baseMatchSetupData,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Flip Coin'),
        findsOneWidget,
      );

      expect(
        find.text('Ready to flip'),
        findsOneWidget,
      );

      expect(
        find.text('Review Match'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Match review displays teams, format, toss and lineups',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(
        900,
        1600,
      );

      tester.view.devicePixelRatio = 1;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _wrap(
          const MatchReadyScreen(
            matchSetupData: _tossCompletedData,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Review Match'),
        findsOneWidget,
      );

      expect(
        find.text('Falcons'),
        findsWidgets,
      );

      expect(
        find.text('Titans'),
        findsWidgets,
      );

      expect(
        find.text('Match Format'),
        findsOneWidget,
      );

      expect(
        find.text('Toss Result'),
        findsOneWidget,
      );

      expect(
        find.text('Batting first'),
        findsOneWidget,
      );

      expect(
        find.text('Bowling first'),
        findsOneWidget,
      );

      expect(
        find.text('Ali'),
        findsOneWidget,
      );

      expect(
        find.text('Hamza'),
        findsOneWidget,
      );

      expect(
        find.text('Start Match'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Opening players screen selects batters and bowler by team',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(
        900,
        2200,
      );

      tester.view.devicePixelRatio = 1;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _wrap(
          const OpeningPlayersScreen(
            matchSetupData: _tossCompletedData,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Select Opening Players'),
        findsOneWidget,
      );

      expect(
        find.textContaining('two batters from Falcons'),
        findsOneWidget,
      );

      expect(
        find.textContaining('one bowler from Titans'),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key('striker_Ali'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key('bowler_Hamza'),
        ),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(
          const Key('striker_Ali'),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key('nonStriker_Ahmed'),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key('bowler_Hamza'),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Ali'),
        findsWidgets,
      );

      expect(
        find.text('Ahmed'),
        findsWidgets,
      );

      expect(
        find.text('Hamza'),
        findsWidgets,
      );

      expect(
        find.text('Start Scoring'),
        findsOneWidget,
      );
    },
  );

  test(
    'match setup data calculates batting and bowling teams',
    () {
      const MatchSetupData batDecision = MatchSetupData(
        teamA: 'Falcons',
        teamB: 'Titans',
        teamAPlayers: <String>[
          'Ali',
          'Ahmed',
        ],
        teamBPlayers: <String>[
          'Hamza',
          'Bilal',
        ],
        tossWinner: 'Falcons',
        decision: 'Bat',
      );

      expect(
        batDecision.battingTeam,
        'Falcons',
      );

      expect(
        batDecision.bowlingTeam,
        'Titans',
      );

      const MatchSetupData bowlDecision = MatchSetupData(
        teamA: 'Falcons',
        teamB: 'Titans',
        teamAPlayers: <String>[
          'Ali',
          'Ahmed',
        ],
        teamBPlayers: <String>[
          'Hamza',
          'Bilal',
        ],
        tossWinner: 'Falcons',
        decision: 'Bowl',
      );

      expect(
        bowlDecision.battingTeam,
        'Titans',
      );

      expect(
        bowlDecision.bowlingTeam,
        'Falcons',
      );
    },
  );
}
