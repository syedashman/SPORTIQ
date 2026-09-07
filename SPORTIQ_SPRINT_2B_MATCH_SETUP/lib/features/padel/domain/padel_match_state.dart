// ignore_for_file: require_trailing_commas

import 'package:flutter/foundation.dart';

enum PadelMatchType { singles, doubles }

@immutable
class PadelPlayer {
  const PadelPlayer({required this.id, required this.name});
  final String id;
  final String name;
}

@immutable
class PadelPair {
  const PadelPair(
      {required this.id, required this.name, required this.players});
  final String id;
  final String name;
  final List<PadelPlayer> players;
}

@immutable
class PadelMatchSettings {
  const PadelMatchSettings({
    this.bestOfSets = 3,
    this.gamesToWinSet = 6,
    this.tieBreakTarget = 7,
    this.goldenPoint = false,
    this.advantageScoring = true,
    this.tieBreakEnabled = true,
    this.title = '',
    this.venue = '',
  });
  final int bestOfSets;
  final int gamesToWinSet;
  final int tieBreakTarget;
  final bool goldenPoint;
  final bool advantageScoring;
  final bool tieBreakEnabled;
  final String title;
  final String venue;

  PadelMatchSettings copyWith({
    int? bestOfSets,
    int? gamesToWinSet,
    int? tieBreakTarget,
    bool? goldenPoint,
    bool? advantageScoring,
    bool? tieBreakEnabled,
    String? title,
    String? venue,
  }) =>
      PadelMatchSettings(
        bestOfSets: bestOfSets ?? this.bestOfSets,
        gamesToWinSet: gamesToWinSet ?? this.gamesToWinSet,
        tieBreakTarget: tieBreakTarget ?? this.tieBreakTarget,
        goldenPoint: goldenPoint ?? this.goldenPoint,
        advantageScoring: advantageScoring ?? this.advantageScoring,
        tieBreakEnabled: tieBreakEnabled ?? this.tieBreakEnabled,
        title: title ?? this.title,
        venue: venue ?? this.venue,
      );

  String? validate() {
    if (bestOfSets <= 0 || bestOfSets.isEven) {
      return 'Best of sets must be odd.';
    }
    if (gamesToWinSet < 1 || tieBreakTarget < 1) {
      return 'Set and tie-break targets must be positive.';
    }
    return null;
  }
}

@immutable
class PadelMatchState {
  const PadelMatchState({
    required this.teamA,
    required this.teamB,
    this.matchType = PadelMatchType.doubles,
    this.settings = const PadelMatchSettings(),
    this.gamesA = 0,
    this.gamesB = 0,
    this.setsA = 0,
    this.setsB = 0,
    this.pointsA = 0,
    this.pointsB = 0,
    this.deuce = false,
    this.advantageTeam,
    this.tieBreak = false,
    this.tieBreakPointsA = 0,
    this.tieBreakPointsB = 0,
    this.servingTeam = 'A',
    this.firstServerId,
    this.serviceOrder = const <String>[],
    this.servicePosition = 0,
    this.completedSets = const <String>[],
    this.isComplete = false,
  });
  final PadelPair teamA;
  final PadelPair teamB;
  final PadelMatchType matchType;
  final PadelMatchSettings settings;
  final int gamesA;
  final int gamesB;
  final int setsA;
  final int setsB;
  final int pointsA;
  final int pointsB;
  final bool deuce;
  final String? advantageTeam;
  final bool tieBreak;
  final int tieBreakPointsA;
  final int tieBreakPointsB;
  final String servingTeam;
  final String? firstServerId;
  final List<String> serviceOrder;
  final int servicePosition;
  final List<String> completedSets;
  final bool isComplete;

  String? get servingPlayerId => serviceOrder.isEmpty
      ? firstServerId
      : serviceOrder[servicePosition % serviceOrder.length];

  String get pointScore {
    if (deuce) {
      return advantageTeam == null
          ? 'Deuce'
          : 'Advantage ${advantageTeam == 'A' ? teamA.name : teamB.name}';
    }
    const List<String> labels = <String>['0', '15', '30', '40'];
    return '${labels[pointsA]} - ${labels[pointsB]}';
  }

  PadelMatchState point({required bool teamASelected}) {
    if (isComplete) return this;
    if (tieBreak) return _tieBreakPoint(teamASelected);
    final String winner = teamASelected ? 'A' : 'B';
    if (deuce) {
      if (settings.goldenPoint || advantageTeam == winner) {
        return _winGame(teamASelected);
      }
      if (advantageTeam != null) return _copy(clearAdvantage: true);
      return _copy(advantageTeam: winner);
    }
    final int nextA = teamASelected ? pointsA + 1 : pointsA;
    final int nextB = teamASelected ? pointsB : pointsB + 1;
    if (settings.advantageScoring &&
        (teamASelected ? nextA : nextB) >= 3 &&
        nextA == nextB) {
      return _copy(pointsA: nextA, pointsB: nextB, deuce: true);
    }
    if ((teamASelected && nextA >= 4 && nextA > nextB) ||
        (!teamASelected && nextB >= 4 && nextB > nextA)) {
      return _winGame(teamASelected);
    }
    return _copy(pointsA: nextA, pointsB: nextB);
  }

  PadelMatchState _winGame(bool teamASelected) {
    final int nextA = teamASelected ? gamesA + 1 : gamesA;
    final int nextB = teamASelected ? gamesB : gamesB + 1;
    if (nextA == settings.gamesToWinSet &&
        nextB == settings.gamesToWinSet &&
        settings.tieBreakEnabled) {
      return _copy(
        gamesA: nextA,
        gamesB: nextB,
        pointsA: 0,
        pointsB: 0,
        deuce: false,
        advantageTeam: null,
        tieBreak: true,
        tieBreakPointsA: 0,
        tieBreakPointsB: 0,
      );
    }
    final bool winsSet =
        (nextA >= settings.gamesToWinSet && nextA - nextB >= 2) ||
            (nextB >= settings.gamesToWinSet && nextB - nextA >= 2);
    if (winsSet) return _winSet(teamASelected, nextA, nextB);
    return _copy(
      gamesA: nextA,
      gamesB: nextB,
      pointsA: 0,
      pointsB: 0,
      deuce: false,
      advantageTeam: null,
      servingTeam: servingTeam == 'A' ? 'B' : 'A',
      servicePosition: _nextServicePosition(),
    );
  }

  PadelMatchState _tieBreakPoint(bool teamASelected) {
    final int nextA = teamASelected ? tieBreakPointsA + 1 : tieBreakPointsA;
    final int nextB = teamASelected ? tieBreakPointsB : tieBreakPointsB + 1;
    final bool won =
        (teamASelected ? nextA : nextB) >= settings.tieBreakTarget &&
            (nextA - nextB).abs() >= 2;
    if (!won) {
      return _copy(
        tieBreakPointsA: nextA,
        tieBreakPointsB: nextB,
        servingTeam: servingTeam == 'A' ? 'B' : 'A',
        servicePosition: _nextTieBreakPosition(),
      );
    }
    return _winSet(teamASelected, gamesA + 1, gamesB + 1,
        tieBreakScore: '$nextA-$nextB');
  }

  PadelMatchState _winSet(bool teamASelected, int finalGamesA, int finalGamesB,
      {String? tieBreakScore}) {
    final int nextSetsA = teamASelected ? setsA + 1 : setsA;
    final int nextSetsB = teamASelected ? setsB : setsB + 1;
    final bool complete = nextSetsA > settings.bestOfSets ~/ 2 ||
        nextSetsB > settings.bestOfSets ~/ 2;
    return _copy(
      gamesA: 0,
      gamesB: 0,
      pointsA: 0,
      pointsB: 0,
      setsA: nextSetsA,
      setsB: nextSetsB,
      tieBreak: false,
      tieBreakPointsA: 0,
      tieBreakPointsB: 0,
      deuce: false,
      advantageTeam: null,
      completedSets: [
        ...completedSets,
        tieBreakScore ?? '$finalGamesA-$finalGamesB'
      ],
      isComplete: complete,
      servingTeam: servingTeam == 'A' ? 'B' : 'A',
      servicePosition: _nextServicePosition(),
    );
  }

  int _nextServicePosition() =>
      serviceOrder.isEmpty ? 0 : (servicePosition + 1) % serviceOrder.length;

  int _nextTieBreakPosition() {
    if (serviceOrder.isEmpty) return 0;
    final int pointsPlayed = tieBreakPointsA + tieBreakPointsB + 1;
    final int offset = pointsPlayed == 1 ? 0 : 1 + (pointsPlayed - 2) ~/ 2;
    return (servicePosition + offset) % serviceOrder.length;
  }

  PadelMatchState _copy({
    int? gamesA,
    int? gamesB,
    int? setsA,
    int? setsB,
    int? pointsA,
    int? pointsB,
    bool? deuce,
    String? advantageTeam,
    bool clearAdvantage = false,
    bool? tieBreak,
    int? tieBreakPointsA,
    int? tieBreakPointsB,
    String? servingTeam,
    String? firstServerId,
    List<String>? serviceOrder,
    int? servicePosition,
    List<String>? completedSets,
    bool? isComplete,
  }) =>
      PadelMatchState(
        teamA: teamA,
        teamB: teamB,
        matchType: matchType,
        settings: settings,
        gamesA: gamesA ?? this.gamesA,
        gamesB: gamesB ?? this.gamesB,
        setsA: setsA ?? this.setsA,
        setsB: setsB ?? this.setsB,
        pointsA: pointsA ?? this.pointsA,
        pointsB: pointsB ?? this.pointsB,
        deuce: deuce ?? this.deuce,
        advantageTeam:
            clearAdvantage ? null : advantageTeam ?? this.advantageTeam,
        tieBreak: tieBreak ?? this.tieBreak,
        tieBreakPointsA: tieBreakPointsA ?? this.tieBreakPointsA,
        tieBreakPointsB: tieBreakPointsB ?? this.tieBreakPointsB,
        servingTeam: servingTeam ?? this.servingTeam,
        firstServerId: firstServerId ?? this.firstServerId,
        serviceOrder: serviceOrder ?? this.serviceOrder,
        servicePosition: servicePosition ?? this.servicePosition,
        completedSets: completedSets ?? this.completedSets,
        isComplete: isComplete ?? this.isComplete,
      );
}
