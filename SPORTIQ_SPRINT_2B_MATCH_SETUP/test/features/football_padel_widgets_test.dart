// ignore_for_file: require_trailing_commas, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportiq/features/football/domain/football_match_state.dart';
import 'package:sportiq/features/football/presentation/screens/football_screens.dart';
import 'package:sportiq/features/padel/domain/padel_match_state.dart';
import 'package:sportiq/features/padel/presentation/screens/padel_screens.dart';

Widget _app(Widget child) => ProviderScope(
      child: MaterialApp(home: child),
    );

const FootballTeam _home = FootballTeam(id: 'h', name: 'Home');
const FootballTeam _away = FootballTeam(id: 'a', name: 'Away');
const PadelPair _pairA = PadelPair(id: 'a', name: 'Pair A', players: []);
const PadelPair _pairB = PadelPair(id: 'b', name: 'Pair B', players: []);

void main() {
  testWidgets('Football settings renders match format and duration controls',
      (WidgetTester tester) async {
    await tester.pumpWidget(_app(const FootballSettingsScreen()));
    expect(find.text('Standard'), findsOneWidget);
    expect(find.text('First-half duration'), findsOneWidget);
    expect(find.text('Penalty shootout'), findsOneWidget);
  });

  testWidgets('Football live event menu exposes card flow',
      (WidgetTester tester) async {
    await tester.pumpWidget(_app(FootballLiveScreen(
        initialMatch:
            const FootballMatchState(homeTeam: _home, awayTeam: _away))));
    await tester.tap(find.text('Add Event'));
    await tester.pumpAndSettle();
    expect(find.text('Yellow Card'), findsOneWidget);
    expect(find.text('Red Card'), findsOneWidget);
    expect(find.text('Substitution'), findsOneWidget);
  });

  testWidgets('Football penalty controls render during shootout',
      (WidgetTester tester) async {
    await tester.pumpWidget(_app(FootballLiveScreen(
        initialMatch: const FootballMatchState(
            homeTeam: _home,
            awayTeam: _away,
            phase: FootballMatchPhase.penaltyShootout))));
    expect(find.text('Home kick: goal'), findsOneWidget);
    expect(find.text('Away kick: miss'), findsOneWidget);
  });

  testWidgets('Football live menu exposes substitution action',
      (WidgetTester tester) async {
    await tester.pumpWidget(_app(FootballLiveScreen(
        initialMatch:
            const FootballMatchState(homeTeam: _home, awayTeam: _away))));
    await tester.tap(find.text('Add Event'));
    await tester.pumpAndSettle();
    expect(find.text('Player Out'), findsNothing);
    expect(find.text('Substitution'), findsOneWidget);
  });

  testWidgets('Padel ready requires first-server selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(_app(const PadelReadyScreen(
        match: PadelMatchState(teamA: _pairA, teamB: _pairB))));
    expect(find.text('Select first server'), findsOneWidget);
    expect(find.text('Start match'), findsOneWidget);
  });

  testWidgets('Padel settings renders scoring controls',
      (WidgetTester tester) async {
    await tester.pumpWidget(_app(const PadelSettingsScreen()));
    expect(find.text('Best of sets'), findsOneWidget);
    expect(find.text('Golden point'), findsOneWidget);
    expect(find.text('Tie-break enabled'), findsOneWidget);
  });
}
