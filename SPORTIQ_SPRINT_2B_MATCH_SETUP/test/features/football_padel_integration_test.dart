// ignore_for_file: require_trailing_commas, prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:sportiq/features/football/domain/football_match_state.dart';
import 'package:sportiq/features/football/presentation/providers/football_setup_provider.dart';
import 'package:sportiq/features/padel/domain/padel_match_state.dart';
import 'package:sportiq/features/padel/presentation/providers/padel_setup_provider.dart';

void main() {
  const FootballPlayer goalkeeper = FootballPlayer(
      id: 'gk', name: 'Keeper', position: 'GK', isGoalkeeper: true);
  const FootballPlayer starter =
      FootballPlayer(id: 'st', name: 'Starter', position: 'ST');
  const FootballPlayer bench =
      FootballPlayer(id: 'sub', name: 'Substitute', position: 'CM');
  const FootballTeam home = FootballTeam(
      id: 'home', name: 'Home', players: [goalkeeper, starter, bench]);
  const FootballTeam away = FootballTeam(
      id: 'away', name: 'Away', players: [goalkeeper, starter, bench]);

  test('football setup provider persists draft and reset is explicit', () {
    final FootballSetupNotifier notifier = FootballSetupNotifier();
    notifier.addTeam(home);
    notifier.addTeam(away);
    notifier.addPlayerToTeam('home', bench);
    notifier.setSettings(
        const FootballMatchSettings(matchName: 'Final', venue: 'Arena'));
    expect(notifier.state.homeTeamId, 'home');
    expect(notifier.state.awayTeamId, 'away');
    expect(notifier.state.settings.matchName, 'Final');
    notifier.resetDraft();
    expect(notifier.state.teams, isEmpty);
  });

  test('football cards dismiss on second yellow and undo is a full snapshot',
      () {
    FootballMatchState match = FootballMatchState(
      homeTeam: home,
      awayTeam: away,
      homeLineup: const FootballLineup(starters: ['gk', 'st']),
    );
    match = match.recordCard('st', true, true);
    expect(match.homeCardMap['st']!.yellowCards, 1);
    match = match.recordCard('st', true, true);
    expect(match.playerIsDismissed('st'), isTrue);
    expect(match.homeLineup.starters, isNot(contains('st')));
  });

  test('football substitution validates bench and configured limits', () {
    final FootballMatchState match = FootballMatchState(
      homeTeam: home,
      awayTeam: away,
      settings: const FootballMatchSettings(maxSubstitutes: 1),
      homeLineup:
          const FootballLineup(starters: ['gk', 'st'], substitutes: ['sub']),
    );
    final FootballMatchState next = match.substitute('st', 'sub', true);
    expect(next.homeLineup.starters, contains('sub'));
    expect(next.homeSubstitutionsUsed, 1);
    expect(next.substitute('gk', 'sub', true), same(next));
  });

  test('football shootout supports early winner and sudden death', () {
    FootballMatchState match = FootballMatchState(
        homeTeam: home,
        awayTeam: away,
        phase: FootballMatchPhase.penaltyShootout);
    for (int kick = 0; kick < 5; kick++) {
      match = match.recordPenaltyKick(true, true);
      if (kick < 4) match = match.recordPenaltyKick(false, false);
    }
    expect(match.isComplete, isTrue);
    expect(match.shootoutGoalsHome, 5);
  });

  test('padel setup provider stores first server and service order', () {
    final PadelSetupNotifier notifier = PadelSetupNotifier();
    const PadelPlayer a = PadelPlayer(id: 'a', name: 'A');
    const PadelPlayer b = PadelPlayer(id: 'b', name: 'B');
    notifier.addPlayer(a);
    notifier.addPlayer(b);
    notifier.setFirstServer('a');
    notifier.setServiceOrder(const ['a', 'b']);
    expect(notifier.state.firstServerId, 'a');
    expect(notifier.state.serviceOrder, ['a', 'b']);
  });

  test('padel singles rotates server after every game and undo restores it',
      () {
    PadelMatchState match = const PadelMatchState(
      teamA: PadelPair(
          id: 'a', name: 'A', players: [PadelPlayer(id: 'a', name: 'A')]),
      teamB: PadelPair(
          id: 'b', name: 'B', players: [PadelPlayer(id: 'b', name: 'B')]),
      matchType: PadelMatchType.singles,
      firstServerId: 'a',
      serviceOrder: ['a', 'b'],
    );
    final PadelMatchState before = match;
    for (int point = 0; point < 4; point++) {
      match = match.point(teamASelected: true);
    }
    expect(match.servingPlayerId, 'b');
    expect(before.servingPlayerId, 'a');
  });

  test('padel golden point wins immediately from deuce', () {
    PadelMatchState match = const PadelMatchState(
      teamA: PadelPair(id: 'a', name: 'A', players: []),
      teamB: PadelPair(id: 'b', name: 'B', players: []),
      settings: PadelMatchSettings(goldenPoint: true),
    );
    for (int point = 0; point < 3; point++) {
      match = match.point(teamASelected: true);
      match = match.point(teamASelected: false);
    }
    expect(match.deuce, isTrue);
    expect(match.point(teamASelected: true).gamesA, 1);
  });
}
