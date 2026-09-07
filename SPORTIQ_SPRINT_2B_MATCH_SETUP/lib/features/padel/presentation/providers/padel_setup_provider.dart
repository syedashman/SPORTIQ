import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/padel_match_state.dart';

class PadelSetupState {
  const PadelSetupState({
    this.players = const <PadelPlayer>[],
    this.matchType = PadelMatchType.doubles,
    this.teamAPlayer1,
    this.teamAPlayer2,
    this.teamBPlayer1,
    this.teamBPlayer2,
    this.settings = const PadelMatchSettings(),
    this.firstServerId,
    this.serviceOrder = const <String>[],
  });
  final List<PadelPlayer> players;
  final PadelMatchType matchType;
  final PadelPlayer? teamAPlayer1;
  final PadelPlayer? teamAPlayer2;
  final PadelPlayer? teamBPlayer1;
  final PadelPlayer? teamBPlayer2;
  final PadelMatchSettings settings;
  final String? firstServerId;
  final List<String> serviceOrder;

  PadelSetupState copyWith({
    List<PadelPlayer>? players,
    PadelMatchType? matchType,
    PadelPlayer? teamAPlayer1,
    PadelPlayer? teamAPlayer2,
    PadelPlayer? teamBPlayer1,
    PadelPlayer? teamBPlayer2,
    PadelMatchSettings? settings,
    String? firstServerId,
    List<String>? serviceOrder,
  }) =>
      PadelSetupState(
        players: players ?? this.players,
        matchType: matchType ?? this.matchType,
        teamAPlayer1: teamAPlayer1 ?? this.teamAPlayer1,
        teamAPlayer2: teamAPlayer2 ?? this.teamAPlayer2,
        teamBPlayer1: teamBPlayer1 ?? this.teamBPlayer1,
        teamBPlayer2: teamBPlayer2 ?? this.teamBPlayer2,
        settings: settings ?? this.settings,
        firstServerId: firstServerId ?? this.firstServerId,
        serviceOrder: serviceOrder ?? this.serviceOrder,
      );
}

class PadelSetupNotifier extends StateNotifier<PadelSetupState> {
  PadelSetupNotifier() : super(const PadelSetupState());

  void addPlayer(PadelPlayer player) {
    state = state.copyWith(players: [...state.players, player]);
  }

  void setMatchType(PadelMatchType value) =>
      state = state.copyWith(matchType: value);

  void setTeamAPlayer1(PadelPlayer? value) {
    if (value != null) state = state.copyWith(teamAPlayer1: value);
  }

  void setTeamAPlayer2(PadelPlayer? value) {
    if (value != null) state = state.copyWith(teamAPlayer2: value);
  }

  void setTeamBPlayer1(PadelPlayer? value) {
    if (value != null) state = state.copyWith(teamBPlayer1: value);
  }

  void setTeamBPlayer2(PadelPlayer? value) {
    if (value != null) state = state.copyWith(teamBPlayer2: value);
  }

  void setSettings(PadelMatchSettings value) =>
      state = state.copyWith(settings: value);

  void setFirstServer(String id) =>
      state = state.copyWith(firstServerId: id);

  void setServiceOrder(List<String> ids) =>
      state = state.copyWith(serviceOrder: List<String>.from(ids));

  void clear() => state = const PadelSetupState();
}

final padelSetupProvider =
    StateNotifierProvider<PadelSetupNotifier, PadelSetupState>(
  (ref) => PadelSetupNotifier(),
);
