// ignore_for_file: curly_braces_in_flow_control_structures, require_trailing_commas

import 'package:flutter/foundation.dart';

enum FootballMatchPhase {
  preMatch,
  firstHalf,
  halftime,
  secondHalf,
  extraTimeFirstHalf,
  extraTimeHalftime,
  extraTimeSecondHalf,
  penaltyShootout,
  fullTime
}

enum FootballMatchFormat { standard, friendly, custom }

enum FootballEventType {
  goal,
  ownGoal,
  penaltyGoal,
  penaltyMissed,
  yellowCard,
  redCard,
  secondYellow,
  substitution,
  injury
}

@immutable
class PlayerCard {
  const PlayerCard(
      {required this.playerId, this.yellowCards = 0, this.redCard = false});
  final String playerId;
  final int yellowCards;
  final bool redCard;

  bool get isDismissed => redCard || yellowCards >= 2;

  PlayerCard addYellow() => PlayerCard(
      playerId: playerId, yellowCards: yellowCards + 1, redCard: redCard);
  PlayerCard addRed() =>
      PlayerCard(playerId: playerId, yellowCards: yellowCards, redCard: true);
}

const List<String> footballPositions = <String>[
  'GK',
  'CB',
  'LB',
  'RB',
  'LWB',
  'RWB',
  'CDM',
  'CM',
  'CAM',
  'LM',
  'RM',
  'LW',
  'RW',
  'CF',
  'ST'
];

@immutable
class FootballPlayer {
  const FootballPlayer(
      {required this.id,
      required this.name,
      this.jerseyNumber,
      this.position = 'CM',
      this.isGoalkeeper = false,
      this.isCaptain = false});
  final String id;
  final String name;
  final int? jerseyNumber;
  final String position;
  final bool isGoalkeeper;
  final bool isCaptain;
  FootballPlayer copyWith(
          {String? name,
          int? jerseyNumber,
          String? position,
          bool? isGoalkeeper,
          bool? isCaptain}) =>
      FootballPlayer(
          id: id,
          name: name ?? this.name,
          jerseyNumber: jerseyNumber ?? this.jerseyNumber,
          position: position ?? this.position,
          isGoalkeeper: isGoalkeeper ?? this.isGoalkeeper,
          isCaptain: isCaptain ?? this.isCaptain);
}

@immutable
class FootballTeam {
  const FootballTeam(
      {required this.id,
      required this.name,
      this.players = const <FootballPlayer>[]});
  final String id;
  final String name;
  final List<FootballPlayer> players;
  FootballTeam copyWith({String? name, List<FootballPlayer>? players}) =>
      FootballTeam(
          id: id, name: name ?? this.name, players: players ?? this.players);
}

@immutable
class FootballLineup {
  const FootballLineup(
      {this.starters = const <String>[], this.substitutes = const <String>[]});
  final List<String> starters;
  final List<String> substitutes;
  FootballLineup copyWith(
          {List<String>? starters, List<String>? substitutes}) =>
      FootballLineup(
          starters: starters ?? this.starters,
          substitutes: substitutes ?? this.substitutes);
}

@immutable
class FootballMatchSettings {
  const FootballMatchSettings(
      {this.halfMinutes = 45,
      this.secondHalfMinutes,
      this.halftimeMinutes = 15,
      this.stoppageTime = true,
      this.extraTime = false,
      this.extraTimeHalfMinutes = 15,
      this.penalties = false,
      this.maxPlayersOnField = 11,
      this.maxSubstitutes = 9,
      this.unlimitedSubstitutions = false,
      this.format = FootballMatchFormat.standard,
      this.matchName = '',
      this.venue = ''});
  final int halfMinutes;
  final int? secondHalfMinutes;
  final int halftimeMinutes;
  final bool stoppageTime;
  final bool extraTime;
  final int extraTimeHalfMinutes;
  final bool penalties;
  final int maxPlayersOnField;
  final int maxSubstitutes;
  final bool unlimitedSubstitutions;
  final FootballMatchFormat format;
  final String matchName;
  final String venue;

  int get effectiveSecondHalfMinutes => secondHalfMinutes ?? halfMinutes;

  FootballMatchSettings copyWith({
    int? halfMinutes,
    int? secondHalfMinutes,
    int? halftimeMinutes,
    bool? stoppageTime,
    bool? extraTime,
    int? extraTimeHalfMinutes,
    bool? penalties,
    int? maxPlayersOnField,
    int? maxSubstitutes,
    bool? unlimitedSubstitutions,
    FootballMatchFormat? format,
    String? matchName,
    String? venue,
  }) =>
      FootballMatchSettings(
        halfMinutes: halfMinutes ?? this.halfMinutes,
        secondHalfMinutes: secondHalfMinutes ?? this.secondHalfMinutes,
        halftimeMinutes: halftimeMinutes ?? this.halftimeMinutes,
        stoppageTime: stoppageTime ?? this.stoppageTime,
        extraTime: extraTime ?? this.extraTime,
        extraTimeHalfMinutes: extraTimeHalfMinutes ?? this.extraTimeHalfMinutes,
        penalties: penalties ?? this.penalties,
        maxPlayersOnField: maxPlayersOnField ?? this.maxPlayersOnField,
        maxSubstitutes: maxSubstitutes ?? this.maxSubstitutes,
        unlimitedSubstitutions:
            unlimitedSubstitutions ?? this.unlimitedSubstitutions,
        format: format ?? this.format,
        matchName: matchName ?? this.matchName,
        venue: venue ?? this.venue,
      );

  String? validate() {
    if (halfMinutes <= 0 || effectiveSecondHalfMinutes <= 0) {
      return 'Half durations must be greater than zero.';
    }
    if (halftimeMinutes < 0 || extraTimeHalfMinutes <= 0) {
      return 'Break and extra-time durations are invalid.';
    }
    if (maxPlayersOnField <= 0 || maxSubstitutes < 0) {
      return 'Player limits are invalid.';
    }
    return null;
  }
}

@immutable
class FootballMatchEvent {
  const FootballMatchEvent(
      {required this.type,
      required this.minute,
      required this.teamId,
      this.playerId,
      this.assistPlayerId,
      this.playerInId,
      this.playerOutId});
  final FootballEventType type;
  final int minute;
  final String teamId;
  final String? playerId;
  final String? assistPlayerId;
  final String? playerInId;
  final String? playerOutId;
}

@immutable
class FootballMatchState {
  const FootballMatchState({
    required this.homeTeam,
    required this.awayTeam,
    this.homeLineup = const FootballLineup(),
    this.awayLineup = const FootballLineup(),
    this.settings = const FootballMatchSettings(),
    this.homeGoals = 0,
    this.awayGoals = 0,
    this.minute = 0,
    this.phase = FootballMatchPhase.firstHalf,
    this.events = const <FootballMatchEvent>[],
    this.dismissedPlayers = const <String>[],
    this.homeSubstitutionsUsed = 0,
    this.awaySubstitutionsUsed = 0,
    this.homeCardMap = const <String, PlayerCard>{},
    this.awayCardMap = const <String, PlayerCard>{},
    this.shootoutGoalsHome = 0,
    this.shootoutGoalsAway = 0,
    this.shootoutKicksTaken = 0,
    this.shootoutMissedHome = const <int>[],
    this.shootoutMissedAway = const <int>[],
    this.isComplete = false,
  });

  final FootballTeam homeTeam;
  final FootballTeam awayTeam;
  final FootballLineup homeLineup;
  final FootballLineup awayLineup;
  final FootballMatchSettings settings;
  final int homeGoals;
  final int awayGoals;
  final int minute;
  final FootballMatchPhase phase;
  final List<FootballMatchEvent> events;
  final List<String> dismissedPlayers;
  final int homeSubstitutionsUsed;
  final int awaySubstitutionsUsed;
  final Map<String, PlayerCard> homeCardMap;
  final Map<String, PlayerCard> awayCardMap;
  final int shootoutGoalsHome;
  final int shootoutGoalsAway;
  final int shootoutKicksTaken;
  final List<int> shootoutMissedHome;
  final List<int> shootoutMissedAway;
  final bool isComplete;

  bool isInPenaltyShootout() => phase == FootballMatchPhase.penaltyShootout;

  bool isInExtraTime() =>
      phase == FootballMatchPhase.extraTimeFirstHalf ||
      phase == FootballMatchPhase.extraTimeHalftime ||
      phase == FootballMatchPhase.extraTimeSecondHalf;

  bool playerIsDismissed(String playerId) =>
      dismissedPlayers.contains(playerId);

  bool canSubstituteFor(String playerId, bool isHomeTeam) {
    final int used = isHomeTeam ? homeSubstitutionsUsed : awaySubstitutionsUsed;
    final int maxSubs = settings.maxSubstitutes;
    return (settings.unlimitedSubstitutions || maxSubs == 0 || used < maxSubs) &&
        !playerIsDismissed(playerId);
  }

  FootballMatchState recordCard(
      String playerId, bool isHomeTeam, bool isYellow) {
    final Map<String, PlayerCard> cardMap =
        isHomeTeam ? homeCardMap : awayCardMap;
    final PlayerCard existing =
        cardMap[playerId] ?? PlayerCard(playerId: playerId);
    final PlayerCard updated =
        isYellow ? existing.addYellow() : existing.addRed();
    final bool wasDismissed = existing.isDismissed;
    final bool nowDismissed = updated.isDismissed;

    List<String> newDismissed = dismissedPlayers;
    if (!wasDismissed && nowDismissed) {
      newDismissed = [...dismissedPlayers, playerId];
    }

    final Map<String, PlayerCard> newCardMap = {...cardMap, playerId: updated};
    final event = FootballMatchEvent(
      type: isYellow && existing.yellowCards == 1
          ? FootballEventType.yellowCard
          : isYellow
              ? FootballEventType.secondYellow
              : FootballEventType.redCard,
      minute: minute,
      teamId: isHomeTeam ? homeTeam.id : awayTeam.id,
      playerId: playerId,
    );

    FootballMatchState next = copyWith(
      homeCardMap: isHomeTeam ? newCardMap : homeCardMap,
      awayCardMap: isHomeTeam ? awayCardMap : newCardMap,
      dismissedPlayers: newDismissed,
      events: [...events, event],
    );
    if (!wasDismissed && nowDismissed) {
      final FootballLineup lineup = isHomeTeam ? homeLineup : awayLineup;
      final FootballLineup updatedLineup = lineup.copyWith(
        starters: lineup.starters.where((String id) => id != playerId).toList(),
        substitutes:
            lineup.substitutes.where((String id) => id != playerId).toList(),
      );
      next = next.copyWith(
        homeLineup: isHomeTeam ? updatedLineup : homeLineup,
        awayLineup: isHomeTeam ? awayLineup : updatedLineup,
      );
    }
    return next;
  }

  FootballMatchState substitute(
      String playerOutId, String playerInId, bool isHomeTeam) {
    final String teamIdOut = isHomeTeam ? homeTeam.id : awayTeam.id;
    if (playerIsDismissed(playerOutId) || playerIsDismissed(playerInId)) {
      return this;
    }

    final FootballLineup oldLineup = isHomeTeam ? homeLineup : awayLineup;
    if (!canSubstituteFor(playerOutId, isHomeTeam)) return this;
    if (!oldLineup.starters.contains(playerOutId)) return this;
    if (oldLineup.starters.contains(playerInId) ||
        !oldLineup.substitutes.contains(playerInId)) return this;

    final FootballLineup newLineup = oldLineup.copyWith(
      starters: [...oldLineup.starters]
        ..remove(playerOutId)
        ..add(playerInId),
      substitutes: [...oldLineup.substitutes]..remove(playerInId),
    );

    final int newSubsUsed =
        isHomeTeam ? homeSubstitutionsUsed + 1 : awaySubstitutionsUsed + 1;
    final event = FootballMatchEvent(
      type: FootballEventType.substitution,
      minute: minute,
      teamId: teamIdOut,
      playerOutId: playerOutId,
      playerInId: playerInId,
    );

    return copyWith(
      homeLineup: isHomeTeam ? newLineup : homeLineup,
      awayLineup: isHomeTeam ? awayLineup : newLineup,
      homeSubstitutionsUsed: isHomeTeam ? newSubsUsed : homeSubstitutionsUsed,
      awaySubstitutionsUsed: isHomeTeam ? awaySubstitutionsUsed : newSubsUsed,
      events: [...events, event],
    );
  }

  FootballMatchState recordPenaltyKick(bool home, bool scored) {
    if (phase != FootballMatchPhase.penaltyShootout) return this;

    int nextKicksTaken = shootoutKicksTaken + 1;
    int nextGoalsHome = shootoutGoalsHome + (scored && home ? 1 : 0);
    int nextGoalsAway = shootoutGoalsAway + (scored && !home ? 1 : 0);

    final int homeKicks = (nextKicksTaken + 1) ~/ 2;
    final int awayKicks = nextKicksTaken ~/ 2;
    final int remainingHome = nextKicksTaken < 10 ? 5 - homeKicks : 0;
    final int remainingAway = nextKicksTaken < 10 ? 5 - awayKicks : 0;
    final bool earlyHome =
        nextKicksTaken < 10 && nextGoalsHome > nextGoalsAway + remainingHome;
    final bool earlyAway =
        nextKicksTaken < 10 && nextGoalsAway > nextGoalsHome + remainingAway;
    final bool suddenDeath =
        nextKicksTaken >= 10 && homeKicks == awayKicks && nextGoalsHome != nextGoalsAway;
    final bool complete = earlyHome || earlyAway || suddenDeath;

    return copyWith(
      shootoutGoalsHome: nextGoalsHome,
      shootoutGoalsAway: nextGoalsAway,
      shootoutKicksTaken: nextKicksTaken,
      shootoutMissedHome: !scored && home
          ? [...shootoutMissedHome, nextKicksTaken]
          : shootoutMissedHome,
      shootoutMissedAway: !scored && !home
          ? [...shootoutMissedAway, nextKicksTaken]
          : shootoutMissedAway,
      isComplete: complete,
    );
  }

  FootballMatchState record(FootballMatchEvent event) {
    final bool homeScoring = event.teamId == homeTeam.id;
    final bool ownGoal = event.type == FootballEventType.ownGoal;
    final bool addsGoal = event.type == FootballEventType.goal ||
        event.type == FootballEventType.penaltyGoal ||
        ownGoal;
    return copyWith(
        homeGoals: addsGoal && (ownGoal ? !homeScoring : homeScoring)
            ? homeGoals + 1
            : homeGoals,
        awayGoals: addsGoal && (ownGoal ? homeScoring : !homeScoring)
            ? awayGoals + 1
            : awayGoals,
        events: <FootballMatchEvent>[...events, event]);
  }

  FootballMatchState tick() {
    if (isComplete) return this;
    if (isInPenaltyShootout()) return this;

    final int nextMinute = minute + 1;
    if (phase == FootballMatchPhase.firstHalf &&
        nextMinute >= settings.halfMinutes)
      return copyWith(
          minute: settings.halfMinutes, phase: FootballMatchPhase.halftime);
    if (phase == FootballMatchPhase.secondHalf &&
        nextMinute >= settings.halfMinutes * 2) {
      if (homeGoals != awayGoals) {
        return copyWith(
            minute: settings.halfMinutes * 2,
            phase: FootballMatchPhase.fullTime,
            isComplete: true);
      }
      if (settings.extraTime) {
        return copyWith(
            minute: settings.halfMinutes * 2,
            phase: FootballMatchPhase.extraTimeFirstHalf);
      }
      if (settings.penalties) {
        return copyWith(
            minute: settings.halfMinutes * 2,
            phase: FootballMatchPhase.penaltyShootout);
      }
      return copyWith(
          minute: settings.halfMinutes * 2,
          phase: FootballMatchPhase.fullTime,
          isComplete: true);
    }
    if (phase == FootballMatchPhase.extraTimeFirstHalf &&
        nextMinute >= settings.halfMinutes + settings.halftimeMinutes) {
      return copyWith(
          minute: settings.halfMinutes + settings.halftimeMinutes,
          phase: FootballMatchPhase.extraTimeHalftime);
    }
    if (phase == FootballMatchPhase.extraTimeSecondHalf &&
        nextMinute >= settings.halfMinutes * 2 + settings.halftimeMinutes) {
      if (homeGoals != awayGoals) {
        return copyWith(
            minute: settings.halfMinutes * 2 + settings.halftimeMinutes,
            phase: FootballMatchPhase.fullTime,
            isComplete: true);
      }
      if (settings.penalties) {
        return copyWith(
            minute: settings.halfMinutes * 2 + settings.halftimeMinutes,
            phase: FootballMatchPhase.penaltyShootout);
      }
      return copyWith(
          minute: settings.halfMinutes * 2 + settings.halftimeMinutes,
          phase: FootballMatchPhase.fullTime,
          isComplete: true);
    }
    return copyWith(minute: nextMinute);
  }

  FootballMatchState advancePhase() {
    if (phase == FootballMatchPhase.halftime)
      return copyWith(phase: FootballMatchPhase.secondHalf);
    if (phase == FootballMatchPhase.extraTimeHalftime)
      return copyWith(phase: FootballMatchPhase.extraTimeSecondHalf);
    return this;
  }

  FootballMatchState finish() =>
      copyWith(phase: FootballMatchPhase.fullTime, isComplete: true);

  FootballMatchState copyWith({
    FootballTeam? homeTeam,
    FootballTeam? awayTeam,
    FootballLineup? homeLineup,
    FootballLineup? awayLineup,
    FootballMatchSettings? settings,
    int? homeGoals,
    int? awayGoals,
    int? minute,
    FootballMatchPhase? phase,
    List<FootballMatchEvent>? events,
    List<String>? dismissedPlayers,
    int? homeSubstitutionsUsed,
    int? awaySubstitutionsUsed,
    Map<String, PlayerCard>? homeCardMap,
    Map<String, PlayerCard>? awayCardMap,
    int? shootoutGoalsHome,
    int? shootoutGoalsAway,
    int? shootoutKicksTaken,
    List<int>? shootoutMissedHome,
    List<int>? shootoutMissedAway,
    bool? isComplete,
  }) =>
      FootballMatchState(
        homeTeam: homeTeam ?? this.homeTeam,
        awayTeam: awayTeam ?? this.awayTeam,
        homeLineup: homeLineup ?? this.homeLineup,
        awayLineup: awayLineup ?? this.awayLineup,
        settings: settings ?? this.settings,
        homeGoals: homeGoals ?? this.homeGoals,
        awayGoals: awayGoals ?? this.awayGoals,
        minute: minute ?? this.minute,
        phase: phase ?? this.phase,
        events: events ?? this.events,
        dismissedPlayers: dismissedPlayers ?? this.dismissedPlayers,
        homeSubstitutionsUsed:
            homeSubstitutionsUsed ?? this.homeSubstitutionsUsed,
        awaySubstitutionsUsed:
            awaySubstitutionsUsed ?? this.awaySubstitutionsUsed,
        homeCardMap: homeCardMap ?? this.homeCardMap,
        awayCardMap: awayCardMap ?? this.awayCardMap,
        shootoutGoalsHome: shootoutGoalsHome ?? this.shootoutGoalsHome,
        shootoutGoalsAway: shootoutGoalsAway ?? this.shootoutGoalsAway,
        shootoutKicksTaken: shootoutKicksTaken ?? this.shootoutKicksTaken,
        shootoutMissedHome: shootoutMissedHome ?? this.shootoutMissedHome,
        shootoutMissedAway: shootoutMissedAway ?? this.shootoutMissedAway,
        isComplete: isComplete ?? this.isComplete,
      );

  String? validateLineup(FootballTeam team, FootballLineup lineup) {
    if (homeTeam.id == awayTeam.id) return 'Teams must be different.';
    if (lineup.starters.length > settings.maxPlayersOnField)
      return 'Too many starting players.';
    if (lineup.substitutes.length > settings.maxSubstitutes)
      return 'Too many substitutes.';
    if (lineup.starters.toSet().length != lineup.starters.length ||
        lineup.starters.any(lineup.substitutes.contains))
      return 'A player cannot be starter and substitute.';
    if (settings.maxPlayersOnField == 11 &&
        !team.players.any((FootballPlayer player) =>
            lineup.starters.contains(player.id) && player.isGoalkeeper))
      return 'Select one goalkeeper among the starters.';
    return null;
  }
}
