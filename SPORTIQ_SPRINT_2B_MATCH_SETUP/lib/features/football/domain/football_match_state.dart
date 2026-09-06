import 'package:flutter/foundation.dart';

@immutable
class FootballMatchState {
  const FootballMatchState({
    required this.homeTeam,
    required this.awayTeam,
    this.homeGoals = 0,
    this.awayGoals = 0,
    this.minute = 0,
    this.events = const <String>[],
    this.isComplete = false,
  });

  final String homeTeam;
  final String awayTeam;
  final int homeGoals;
  final int awayGoals;
  final int minute;
  final List<String> events;
  final bool isComplete;

  FootballMatchState goal({required bool home}) => FootballMatchState(
        homeTeam: homeTeam,
        awayTeam: awayTeam,
        homeGoals: home ? homeGoals + 1 : homeGoals,
        awayGoals: home ? awayGoals : awayGoals + 1,
        minute: minute,
        events: [...events, '${home ? homeTeam : awayTeam} goal · $minute\''],
        isComplete: isComplete,
      );

  FootballMatchState card(String team, String type) => FootballMatchState(
        homeTeam: homeTeam,
        awayTeam: awayTeam,
        homeGoals: homeGoals,
        awayGoals: awayGoals,
        minute: minute,
        events: [...events, '$type card · $team · $minute\''],
        isComplete: isComplete,
      );

  FootballMatchState tick() => FootballMatchState(
        homeTeam: homeTeam,
        awayTeam: awayTeam,
        homeGoals: homeGoals,
        awayGoals: awayGoals,
        minute: minute >= 90 ? minute : minute + 1,
        events: events,
        isComplete: isComplete,
      );

  FootballMatchState finish() => FootballMatchState(
        homeTeam: homeTeam,
        awayTeam: awayTeam,
        homeGoals: homeGoals,
        awayGoals: awayGoals,
        minute: minute,
        events: events,
        isComplete: true,
      );
}
