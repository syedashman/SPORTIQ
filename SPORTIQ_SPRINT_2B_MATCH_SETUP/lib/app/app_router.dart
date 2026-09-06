import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/analytics/presentation/screens/player_analytics_screen.dart';
import '../features/auth/presentation/screens/account_created_screen.dart';
import '../features/auth/presentation/screens/choose_sport_screen.dart';
import '../features/auth/presentation/screens/create_account_options_screen.dart';
import '../features/auth/presentation/screens/email_signup_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/reset_link_sent_screen.dart';
import '../features/auth/presentation/screens/verify_email_screen.dart';
import '../features/cricket_scoring/domain/cricket_match_state.dart';
import '../features/cricket_scoring/presentation/screens/live_scoring_screen.dart';
import '../features/cricket_scoring/presentation/screens/match_summary_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/football/domain/football_match_state.dart';
import '../features/football/presentation/screens/football_screens.dart';
import '../features/live_spectator/presentation/screens/live_spectator_screen.dart';
import '../features/match_setup/domain/match_setup_data.dart';
import '../features/match_setup/presentation/screens/add_players_screen.dart';
import '../features/match_setup/presentation/screens/create_teams_screen.dart';
import '../features/match_setup/presentation/screens/cricket_settings_screen.dart';
import '../features/match_setup/presentation/screens/match_entry_screen.dart';
import '../features/match_setup/presentation/screens/match_ready_screen.dart';
import '../features/match_setup/presentation/screens/opening_players_screen.dart';
import '../features/match_setup/presentation/screens/toss_setup_screen.dart';
import '../features/onboarding/presentation/screens/get_started_screen.dart';
import '../features/onboarding/presentation/screens/splash_screen.dart';
import '../features/onboarding/presentation/screens/welcome_screen.dart';
import '../features/padel/domain/padel_match_state.dart';
import '../features/padel/presentation/screens/padel_screens.dart';
import '../features/profile/presentation/screens/complete_profile_screen.dart';
import '../features/scorecard/presentation/screens/scorecard_screen.dart';
import '../features/teams/presentation/screens/teams_screens.dart';
import '../features/tournaments/presentation/screens/tournament_screens.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String getStarted = '/get-started';
  static const String chooseSport = '/choose-sport';

  static const String login = '/login';
  static const String signup = '/signup';
  static const String emailSignup = '/signup/email';
  static const String forgotPassword = '/forgot-password';
  static const String resetLinkSent = '/reset-link-sent';
  static const String verifyEmail = '/verify-email';
  static const String accountCreated = '/account-created';

  static const String completeProfile = '/profile/complete';
  static const String profileReminder = '/profile/reminder';

  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String search = '/search';
  static const String teams = '/teams';
  static const String tournaments = '/tournaments';

  static const String teamDetails = '/teams/:id';
  static const String teamPlayers = '/teams/:id/players';
  static const String teamInvite = '/teams/:id/invite';
  static const String teamSetup = '/match/:id/team-setup';

  static const String createTournament = '/tournaments/create';
  static const String tournamentDetails = '/tournaments/:id';
  static const String tournamentFixtures = '/tournaments/:id/fixtures';
  static const String tournamentStandings = '/tournaments/:id/standings';
  static const String tournamentBracket = '/tournaments/:id/bracket';
  static const String tournamentRankings = '/tournaments/:id/rankings';

  static const String matchEntry = '/match/entry';
  static const String createTeams = '/match/create/teams';
  static const String addPlayers = '/match/create/players';
  static const String cricketSettings = '/match/create/settings';
  static const String cricketToss = '/match/create/toss';
  static const String cricketReady = '/match/create/ready';
  static const String cricketOpeningPlayers = '/match/create/opening-players';
  static const String cricketLiveScoring = '/match/demo/score';

  static const String createMatch = '/match/create';
  static const String matchSetup = '/match/:id/setup';
  static const String matchLineup = '/match/:id/lineup';
  static const String matchReady = '/match/:id/ready';
  static const String tossSetup = '/match/:id/toss/setup';
  static const String tossFlip = '/match/:id/toss/flip';
  static const String tossResult = '/match/:id/toss/result';

  static const String liveScoring = '/match/:id/score';
  static const String liveMatch = '/match/:id/live';
  static const String matchEvents = '/match/:id/events';
  static const String matchSummary = '/match/:id/summary';
  static const String scorecard = '/match/:id/scorecard';

  static const String playerAnalytics = '/players/:id/analytics';

  static const String footballMatch = '/football/match';
  static const String footballLineup = '/football/match/lineup';
  static const String footballLive = '/football/match/live';
  static const String footballSummary = '/football/match/summary';
  static const String padelMatch = '/padel/match';
  static const String padelReady = '/padel/match/ready';
  static const String padelLive = '/padel/match/live';
  static const String padelSummary = '/padel/match/summary';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.welcome,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const WelcomeScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.getStarted,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const GetStartedScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.chooseSport,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const ChooseSportScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const CreateAccountOptionsScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.emailSignup,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const EmailSignupScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.resetLinkSent,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        final String email =
            state.extra is String ? state.extra! as String : '';

        return ResetLinkSentScreen(
          email: email,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.verifyEmail,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const VerifyEmailScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.accountCreated,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const AccountCreatedScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.completeProfile,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const CompleteProfileScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.profileReminder,
      builder: (BuildContext context, GoRouterState state) =>
          const ProfileReminderScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (BuildContext context, GoRouterState state) =>
          const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (BuildContext context, GoRouterState state) =>
          const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (BuildContext context, GoRouterState state) =>
          const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (BuildContext context, GoRouterState state) =>
          const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (BuildContext context, GoRouterState state) =>
          const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.search,
      builder: (BuildContext context, GoRouterState state) =>
          const SearchScreen(),
    ),
    GoRoute(
      path: AppRoutes.teams,
      builder: (BuildContext context, GoRouterState state) =>
          const TeamsScreen(),
    ),
    GoRoute(
      path: AppRoutes.teamDetails,
      builder: (BuildContext context, GoRouterState state) => TeamDetailsScreen(
        teamId: state.pathParameters['id'] ?? 'demo',
      ),
    ),
    GoRoute(
      path: AppRoutes.teamPlayers,
      builder: (BuildContext context, GoRouterState state) => TeamPlayersScreen(
        teamId: state.pathParameters['id'] ?? 'demo',
      ),
    ),
    GoRoute(
      path: AppRoutes.teamInvite,
      builder: (BuildContext context, GoRouterState state) => TeamInviteScreen(
        teamId: state.pathParameters['id'] ?? 'demo',
      ),
    ),
    GoRoute(
      path: AppRoutes.teamSetup,
      builder: (BuildContext context, GoRouterState state) =>
          const TeamSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.createTournament,
      builder: (BuildContext context, GoRouterState state) =>
          const CreateTournamentScreen(),
    ),
    GoRoute(
      path: AppRoutes.tournaments,
      builder: (BuildContext context, GoRouterState state) =>
          const TournamentListScreen(),
    ),
    GoRoute(
      path: AppRoutes.tournamentDetails,
      builder: (BuildContext context, GoRouterState state) =>
          TournamentDetailsScreen(
        tournamentId: state.pathParameters['id'] ?? 'demo',
      ),
    ),
    GoRoute(
      path: AppRoutes.tournamentFixtures,
      builder: (BuildContext context, GoRouterState state) =>
          TournamentFixturesScreen(
        tournamentId: state.pathParameters['id'] ?? 'demo',
      ),
    ),
    GoRoute(
      path: AppRoutes.tournamentStandings,
      builder: (BuildContext context, GoRouterState state) =>
          TournamentStandingsScreen(
        tournamentId: state.pathParameters['id'] ?? 'demo',
      ),
    ),
    GoRoute(
      path: AppRoutes.tournamentBracket,
      builder: (BuildContext context, GoRouterState state) =>
          TournamentBracketScreen(
        tournamentId: state.pathParameters['id'] ?? 'demo',
      ),
    ),
    GoRoute(
      path: AppRoutes.tournamentRankings,
      builder: (BuildContext context, GoRouterState state) =>
          TournamentRankingsScreen(
        tournamentId: state.pathParameters['id'] ?? 'demo',
      ),
    ),

    // Sprint 2B + Sprint 2C match setup flow.
    GoRoute(
      path: AppRoutes.matchEntry,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const MatchEntryScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.createTeams,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return const CreateTeamsScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.addPlayers,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        final Map<String, dynamic> data = state.extra is Map<String, dynamic>
            ? state.extra! as Map<String, dynamic>
            : const <String, dynamic>{};

        return AddPlayersScreen(
          teamA: data['teamA'] as String? ?? 'Team A',
          teamB: data['teamB'] as String? ?? 'Team B',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.cricketSettings,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return CricketSettingsScreen(
          matchSetupData: _readMatchSetupData(
            state.extra,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.cricketToss,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return TossSetupScreen(
          matchSetupData: _readMatchSetupData(
            state.extra,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.cricketReady,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return MatchReadyScreen(
          matchSetupData: _readMatchSetupData(
            state.extra,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.cricketOpeningPlayers,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        return OpeningPlayersScreen(
          matchSetupData: _readMatchSetupData(
            state.extra,
          ),
        );
      },
    ),

    // Live scoring receives the complete match setup data.
    GoRoute(
      path: AppRoutes.cricketLiveScoring,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        final MatchSetupData matchSetupData = _readMatchSetupData(
          state.extra,
        );

        return LiveScoringScreen(
          matchSetupData: matchSetupData,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.createMatch,
      redirect: (
        BuildContext context,
        GoRouterState state,
      ) {
        return AppRoutes.matchEntry;
      },
    ),
    GoRoute(
      path: AppRoutes.matchSetup,
      builder: (BuildContext context, GoRouterState state) =>
          const MatchEntryScreen(),
    ),
    GoRoute(
      path: AppRoutes.matchLineup,
      builder: (BuildContext context, GoRouterState state) =>
          OpeningPlayersScreen(
        matchSetupData: _readMatchSetupData(state.extra),
      ),
    ),
    GoRoute(
      path: AppRoutes.matchReady,
      builder: (BuildContext context, GoRouterState state) => MatchReadyScreen(
        matchSetupData: _readMatchSetupData(state.extra),
      ),
    ),
    GoRoute(
      path: AppRoutes.tossSetup,
      builder: (BuildContext context, GoRouterState state) => TossSetupScreen(
        matchSetupData: _readMatchSetupData(state.extra),
      ),
    ),
    GoRoute(
      path: AppRoutes.tossFlip,
      builder: (BuildContext context, GoRouterState state) => TossSetupScreen(
        matchSetupData: _readMatchSetupData(state.extra),
      ),
    ),
    GoRoute(
      path: AppRoutes.tossResult,
      builder: (BuildContext context, GoRouterState state) => TossSetupScreen(
        matchSetupData: _readMatchSetupData(state.extra),
      ),
    ),
    GoRoute(
      path: AppRoutes.liveScoring,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        final MatchSetupData matchSetupData = _readMatchSetupData(
          state.extra,
        );

        return LiveScoringScreen(
          matchSetupData: matchSetupData,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.liveMatch,
      builder: (BuildContext context, GoRouterState state) =>
          LiveSpectatorScreen(
        matchId: state.pathParameters['id'] ?? 'demo',
      ),
    ),
    GoRoute(
      path: AppRoutes.matchEvents,
      builder: (BuildContext context, GoRouterState state) => MatchEventsScreen(
        matchId: state.pathParameters['id'] ?? 'demo',
      ),
    ),
    GoRoute(
      path: AppRoutes.matchSummary,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        final CricketMatchSnapshot snapshot =
            state.extra is CricketMatchSnapshot
                ? state.extra! as CricketMatchSnapshot
                : _emptyMatchSnapshot();

        return MatchSummaryScreen(
          snapshot: snapshot,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.scorecard,
      builder: (
        BuildContext context,
        GoRouterState state,
      ) {
        final CricketMatchSnapshot snapshot =
            state.extra is CricketMatchSnapshot
                ? state.extra! as CricketMatchSnapshot
                : _emptyMatchSnapshot();

        return ScorecardScreen(
          snapshot: snapshot,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.playerAnalytics,
      builder: (BuildContext context, GoRouterState state) =>
          PlayerAnalyticsScreen(
        playerId: state.pathParameters['id'] ?? 'demo',
      ),
    ),
    GoRoute(
      path: AppRoutes.footballMatch,
      builder: (BuildContext context, GoRouterState state) =>
          const FootballMatchEntryScreen(),
    ),
    GoRoute(
      path: AppRoutes.footballLineup,
      builder: (BuildContext context, GoRouterState state) =>
          const FootballLineupScreen(),
    ),
    GoRoute(
      path: AppRoutes.footballLive,
      builder: (BuildContext context, GoRouterState state) =>
          const FootballLiveScreen(),
    ),
    GoRoute(
      path: AppRoutes.footballSummary,
      builder: (BuildContext context, GoRouterState state) =>
          FootballSummaryScreen(
        match: state.extra is FootballMatchState
            ? state.extra! as FootballMatchState
            : const FootballMatchState(
                homeTeam: 'Falcons FC',
                awayTeam: 'City United',
              ),
      ),
    ),
    GoRoute(
      path: AppRoutes.padelMatch,
      builder: (BuildContext context, GoRouterState state) =>
          const PadelMatchEntryScreen(),
    ),
    GoRoute(
      path: AppRoutes.padelReady,
      builder: (BuildContext context, GoRouterState state) =>
          const PadelReadyScreen(),
    ),
    GoRoute(
      path: AppRoutes.padelLive,
      builder: (BuildContext context, GoRouterState state) =>
          const PadelLiveScreen(),
    ),
    GoRoute(
      path: AppRoutes.padelSummary,
      builder: (BuildContext context, GoRouterState state) =>
          PadelSummaryScreen(
        match: state.extra is PadelMatchState
            ? state.extra! as PadelMatchState
            : const PadelMatchState(teamA: 'Pair A', teamB: 'Pair B'),
      ),
    ),
  ],
);

MatchSetupData _readMatchSetupData(Object? extra) {
  if (extra is MatchSetupData) {
    return extra;
  }

  if (extra is Map<String, dynamic>) {
    final String teamA = extra['teamA'] as String? ?? 'Team A';
    final String teamB = extra['teamB'] as String? ?? 'Team B';

    final List<String> teamAPlayers = extra['teamAPlayers'] is List<String>
        ? List<String>.from(
            extra['teamAPlayers'] as List<String>,
          )
        : <String>[
            '$teamA Captain',
            '$teamA Player 2',
          ];

    final List<String> teamBPlayers = extra['teamBPlayers'] is List<String>
        ? List<String>.from(
            extra['teamBPlayers'] as List<String>,
          )
        : <String>[
            '$teamB Captain',
            '$teamB Player 2',
          ];

    return MatchSetupData(
      teamA: teamA,
      teamB: teamB,
      teamAPlayers: teamAPlayers,
      teamBPlayers: teamBPlayers,
      overs: extra['overs'] as int? ?? 5,
      playersPerSide: extra['playersPerSide'] as int? ?? 2,
      ballsPerOver: extra['ballsPerOver'] as int? ?? 6,
      tossWinner: extra['tossWinner'] as String?,
      decision: extra['decision'] as String?,
      striker: extra['striker'] as String?,
      nonStriker: extra['nonStriker'] as String?,
      openingBowler: extra['openingBowler'] as String?,
    );
  }

  return const MatchSetupData(
    teamA: 'Team A',
    teamB: 'Team B',
    teamAPlayers: <String>[
      'Team A Captain',
      'Team A Player 2',
    ],
    teamBPlayers: <String>[
      'Team B Captain',
      'Team B Player 2',
    ],
    overs: 5,
    playersPerSide: 2,
    ballsPerOver: 6,
  );
}

CricketMatchSnapshot _emptyMatchSnapshot() {
  return const CricketMatchSnapshot(
    teamA: 'Team A',
    teamB: 'Team B',
    overs: 5,
    currentInnings: 1,
    firstInnings: null,
    secondInnings: InningsSnapshot(
      battingTeam: 'Team A',
      bowlingTeam: 'Team B',
      runs: 0,
      wickets: 0,
      legalBalls: 0,
      events: <CricketBallEvent>[],
    ),
    isComplete: false,
    winnerText: '',
  );
}
