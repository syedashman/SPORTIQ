// ignore_for_file: require_trailing_commas

import 'package:flutter_test/flutter_test.dart';
import 'package:sportiq/features/football/domain/football_match_state.dart';
import 'package:sportiq/features/padel/domain/padel_match_state.dart';

void main() {
  group('FootballMatchState', () {
    const home = FootballTeam(id: 'home', name: 'Home');
    const away = FootballTeam(id: 'away', name: 'Away');

    test('records goals and events without changing regulation rules', () {
      const match = FootballMatchState(homeTeam: home, awayTeam: away);
      final next = match.record(const FootballMatchEvent(
        type: FootballEventType.goal,
        minute: 12,
        teamId: 'home',
      ));
      expect(next.homeGoals, 1);
      expect(next.awayGoals, 0);
      expect(next.events, hasLength(1));

      final ownGoal = next.record(const FootballMatchEvent(
        type: FootballEventType.ownGoal,
        minute: 13,
        teamId: 'home',
      ));
      expect(ownGoal.homeGoals, 1);
      expect(ownGoal.awayGoals, 1);
    });

    test('moves from first half to halftime and second half', () {
      const match = FootballMatchState(
        homeTeam: home,
        awayTeam: away,
        settings: FootballMatchSettings(halfMinutes: 1),
      );
      final halftime = match.tick();
      expect(halftime.phase, FootballMatchPhase.halftime);
      expect(halftime.advancePhase().phase, FootballMatchPhase.secondHalf);
    });

    test('requires a goalkeeper for standard lineups', () {
      const player = FootballPlayer(id: 'p1', name: 'Player');
      const team = FootballTeam(id: 'home', name: 'Home', players: [player]);
      const match = FootballMatchState(homeTeam: team, awayTeam: away);
      expect(match.validateLineup(team, const FootballLineup(starters: ['p1'])),
          contains('goalkeeper'));
    });
  });

  group('PadelMatchState', () {
    const pairA = PadelPair(id: 'a', name: 'A', players: []);
    const pairB = PadelPair(id: 'b', name: 'B', players: []);

    test('supports deuce, advantage, lost advantage, and game win', () {
      PadelMatchState match = const PadelMatchState(teamA: pairA, teamB: pairB);
      for (var index = 0; index < 3; index++) {
        match = match.point(teamASelected: true);
        match = match.point(teamASelected: false);
      }
      expect(match.deuce, isTrue);
      match = match.point(teamASelected: true);
      expect(match.advantageTeam, 'A');
      match = match.point(teamASelected: false);
      expect(match.advantageTeam, isNull);
      match = match.point(teamASelected: false);
      match = match.point(teamASelected: false);
      expect(match.gamesB, 1);
      expect(match.pointScore, '0 - 0');
    });

    test('starts a tiebreak at six games each and completes a set', () {
      PadelMatchState match = const PadelMatchState(teamA: pairA, teamB: pairB);
      for (var game = 0; game < 6; game++) {
        for (var point = 0; point < 4; point++) {
          match = match.point(teamASelected: true);
        }
        for (var point = 0; point < 4; point++) {
          match = match.point(teamASelected: false);
        }
      }
      expect(match.tieBreak, isTrue);
      for (var point = 0; point < 7; point++) {
        match = match.point(teamASelected: true);
      }
      expect(match.setsA, 1);
      expect(match.completedSets, contains('7-0'));
    });
  });
}
