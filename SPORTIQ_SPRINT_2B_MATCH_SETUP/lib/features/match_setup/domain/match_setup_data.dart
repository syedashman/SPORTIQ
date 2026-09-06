class MatchSetupData {
  const MatchSetupData({
    required this.teamA,
    required this.teamB,
    this.teamAPlayers = const <String>[],
    this.teamBPlayers = const <String>[],
    this.overs = 5,
    this.playersPerSide = 6,
    this.ballsPerOver = 6,
    this.tossWinner,
    this.decision,
    this.striker,
    this.nonStriker,
    this.openingBowler,
  });

  final String teamA;
  final String teamB;

  final List<String> teamAPlayers;
  final List<String> teamBPlayers;

  final int overs;
  final int playersPerSide;
  final int ballsPerOver;

  final String? tossWinner;
  final String? decision;

  final String? striker;
  final String? nonStriker;
  final String? openingBowler;

  String get otherTeam {
    if (tossWinner == teamA) {
      return teamB;
    }

    return teamA;
  }

  String get battingTeam {
    if (tossWinner == null || decision == null) {
      return teamA;
    }

    if (decision == 'Bat') {
      return tossWinner!;
    }

    return otherTeam;
  }

  String get bowlingTeam {
    if (battingTeam == teamA) {
      return teamB;
    }

    return teamA;
  }

  List<String> get battingPlayers {
    if (battingTeam == teamA) {
      return List<String>.unmodifiable(teamAPlayers);
    }

    return List<String>.unmodifiable(teamBPlayers);
  }

  List<String> get bowlingPlayers {
    if (bowlingTeam == teamA) {
      return List<String>.unmodifiable(teamAPlayers);
    }

    return List<String>.unmodifiable(teamBPlayers);
  }

  bool get hasEnoughOpeningPlayers {
    return battingPlayers.length >= 2 && bowlingPlayers.isNotEmpty;
  }

  bool get hasOpeningPlayersSelected {
    return striker != null &&
        nonStriker != null &&
        openingBowler != null &&
        striker != nonStriker;
  }

  MatchSetupData copyWith({
    String? teamA,
    String? teamB,
    List<String>? teamAPlayers,
    List<String>? teamBPlayers,
    int? overs,
    int? playersPerSide,
    int? ballsPerOver,
    String? tossWinner,
    String? decision,
    String? striker,
    String? nonStriker,
    String? openingBowler,
    bool clearTossWinner = false,
    bool clearDecision = false,
    bool clearStriker = false,
    bool clearNonStriker = false,
    bool clearOpeningBowler = false,
  }) {
    return MatchSetupData(
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      teamAPlayers: List<String>.unmodifiable(
        teamAPlayers ?? this.teamAPlayers,
      ),
      teamBPlayers: List<String>.unmodifiable(
        teamBPlayers ?? this.teamBPlayers,
      ),
      overs: overs ?? this.overs,
      playersPerSide: playersPerSide ?? this.playersPerSide,
      ballsPerOver: ballsPerOver ?? this.ballsPerOver,
      tossWinner: clearTossWinner ? null : tossWinner ?? this.tossWinner,
      decision: clearDecision ? null : decision ?? this.decision,
      striker: clearStriker ? null : striker ?? this.striker,
      nonStriker: clearNonStriker ? null : nonStriker ?? this.nonStriker,
      openingBowler:
          clearOpeningBowler ? null : openingBowler ?? this.openingBowler,
    );
  }
}
