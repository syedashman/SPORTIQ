// ignore_for_file: require_trailing_commas

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/football_match_state.dart';

class FootballSetupState {
  const FootballSetupState({
    this.teams = const <FootballTeam>[],
    this.homeTeamId,
    this.awayTeamId,
    this.homeLineup = const FootballLineup(),
    this.awayLineup = const FootballLineup(),
    this.settings = const FootballMatchSettings(),
  });

  final List<FootballTeam> teams;
  final String? homeTeamId;
  final String? awayTeamId;
  final FootballLineup homeLineup;
  final FootballLineup awayLineup;
  final FootballMatchSettings settings;

  FootballTeam? get homeTeam => _team(homeTeamId);
  FootballTeam? get awayTeam => _team(awayTeamId);

  FootballTeam? _team(String? id) {
    if (id == null) return null;
    for (final FootballTeam team in teams) {
      if (team.id == id) return team;
    }
    return null;
  }

  FootballSetupState copyWith({
    List<FootballTeam>? teams,
    String? homeTeamId,
    String? awayTeamId,
    FootballLineup? homeLineup,
    FootballLineup? awayLineup,
    FootballMatchSettings? settings,
  }) =>
      FootballSetupState(
        teams: teams ?? this.teams,
        homeTeamId: homeTeamId ?? this.homeTeamId,
        awayTeamId: awayTeamId ?? this.awayTeamId,
        homeLineup: homeLineup ?? this.homeLineup,
        awayLineup: awayLineup ?? this.awayLineup,
        settings: settings ?? this.settings,
      );
}

class FootballSetupNotifier extends StateNotifier<FootballSetupState> {
  FootballSetupNotifier() : super(const FootballSetupState());

  void addTeam(FootballTeam team) {
    final List<FootballTeam> teams = [...state.teams, team];
    String? home = state.homeTeamId;
    String? away = state.awayTeamId;
    home ??= team.id;
    if (away == null && team.id != home) away = team.id;
    state = state.copyWith(teams: teams, homeTeamId: home, awayTeamId: away);
  }

  void addPlayerToTeam(String teamId, FootballPlayer player) {
    state = state.copyWith(
      teams: state.teams
          .map((FootballTeam team) => team.id == teamId
              ? team.copyWith(players: [...team.players, player])
              : team)
          .toList(),
    );
  }

  void setHomeTeam(String? value) {
    if (value == null) return;
    state = state.copyWith(homeTeamId: value);
  }

  void setAwayTeam(String? value) {
    if (value == null) return;
    state = state.copyWith(awayTeamId: value);
  }

  void setLineups({
    required FootballLineup home,
    required FootballLineup away,
  }) {
    state = state.copyWith(homeLineup: home, awayLineup: away);
  }

  void setSettings(FootballMatchSettings value) {
    state = state.copyWith(settings: value);
  }

  void resetDraft() => state = const FootballSetupState();
}

final footballSetupProvider =
    StateNotifierProvider<FootballSetupNotifier, FootballSetupState>(
  (ref) => FootballSetupNotifier(),
);
