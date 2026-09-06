# SPORTIQ Sprint 2C — Live Cricket Scoring

Implemented:
- Live scoring route connected from Match Ready
- Runs: 0, 1, 2, 3, 4, 6
- Wicket, Wide, No Ball, Bye, Leg Bye
- Legal-ball and over tracking
- Undo last event
- CRR, target, runs required, balls remaining, RRR
- First-to-second innings transition
- Match completion and winner calculation
- Match summary
- First/second innings scorecard tabs
- Batting, bowling, innings details, and ball-by-ball sections
- Widget and controller tests in `test/features/cricket_scoring_test.dart`

Integration note:
- Player names/stat allocation are UI placeholders until real team/player persistence is connected.
- Match persistence, Supabase save, and advanced analytics remain for later sprints.
