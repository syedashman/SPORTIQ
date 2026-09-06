// ignore_for_file: require_trailing_commas

import 'package:flutter/foundation.dart';

@immutable
class PadelMatchState {
  const PadelMatchState({
    required this.teamA,
    required this.teamB,
    this.gamesA = 0,
    this.gamesB = 0,
    this.setsA = 0,
    this.setsB = 0,
    this.pointsA = 0,
    this.pointsB = 0,
    this.servingTeam = 'A',
    this.isComplete = false,
  });

  final String teamA;
  final String teamB;
  final int gamesA;
  final int gamesB;
  final int setsA;
  final int setsB;
  final int pointsA;
  final int pointsB;
  final String servingTeam;
  final bool isComplete;

  PadelMatchState point({required bool teamASelected}) {
    final nextA = teamASelected ? pointsA + 1 : pointsA;
    final nextB = teamASelected ? pointsB : pointsB + 1;
    final winsGame = nextA >= 4 || nextB >= 4;
    if (!winsGame) {
      return _copy(pointsA: nextA, pointsB: nextB);
    }
    final aGame = teamASelected ? gamesA + 1 : gamesA;
    final bGame = teamASelected ? gamesB : gamesB + 1;
    final winsSet = aGame >= 6 || bGame >= 6;
    return _copy(
      gamesA: winsSet ? 0 : aGame,
      gamesB: winsSet ? 0 : bGame,
      setsA: winsSet && teamASelected ? setsA + 1 : setsA,
      setsB: winsSet && !teamASelected ? setsB + 1 : setsB,
      pointsA: 0,
      pointsB: 0,
      isComplete: (setsA + (winsSet && teamASelected ? 1 : 0) >= 2) ||
          (setsB + (winsSet && !teamASelected ? 1 : 0) >= 2),
    );
  }

  PadelMatchState _copy(
          {int? gamesA,
          int? gamesB,
          int? setsA,
          int? setsB,
          int? pointsA,
          int? pointsB,
          bool? isComplete}) =>
      PadelMatchState(
          teamA: teamA,
          teamB: teamB,
          gamesA: gamesA ?? this.gamesA,
          gamesB: gamesB ?? this.gamesB,
          setsA: setsA ?? this.setsA,
          setsB: setsB ?? this.setsB,
          pointsA: pointsA ?? this.pointsA,
          pointsB: pointsB ?? this.pointsB,
          servingTeam: servingTeam == 'A' ? 'B' : 'A',
          isComplete: isComplete ?? this.isComplete);
}
