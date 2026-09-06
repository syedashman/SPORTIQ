# SCREEN_MANIFEST

## Purpose

This document defines the official SPORTIQ UI inventory.

It is the single source of truth for every approved screen.

No developer is allowed to implement a screen that is not listed here.

No developer is allowed to redesign any approved screen.

The Stitch export is the visual reference only.

Flutter implementation must follow this manifest.

---

# AUTHENTICATION

| Screen | Stitch Reference | Route | Status |
|---------|-----------------|-------|--------|
| Splash | splash_screen_v4 | /splash | FINAL |
| Welcome | welcome_screen_v3_1 | /welcome | FINAL |
| Get Started | get_started_screen | /get-started | FINAL |
| Choose Sport | choose_your_sport_2 | /choose-sport | FINAL |
| Login | login_screen | /login | FINAL |
| Create Account Options | create_account_options | /signup | FINAL |
| Create Account Email | create_account_via_email | /signup/email | FINAL |
| Forgot Password | forgot_password | /forgot-password | FINAL |
| Verify Email | email_verification_polished | /verify-email | FINAL |
| Account Created | account_created_success | /account-created | FINAL |

---

# PROFILE

| Screen | Stitch Reference | Route | Status |
|---------|-----------------|-------|--------|
| Complete Profile | complete_profile | /profile/complete | FINAL |
| Profile Reminder | profile_reminder | /profile/reminder | FINAL |
| Profile | profile | /profile | FINAL |
| Edit Profile | edit_profile | /profile/edit | FINAL |
| Settings | settings | /settings | FINAL |
| Notifications | notifications | /notifications | FINAL |
| Global Search | global_search | /search | FINAL |

---

# DASHBOARD

| Screen | Stitch Reference | Route | Status |
|---------|-----------------|-------|--------|
| Dashboard | dashboard | /dashboard | FINAL |

---

# TEAMS

| Screen | Stitch Reference | Route | Status |
|---------|-----------------|-------|--------|
| Team Details | team_details | /teams/:id | FINAL |
| Team Players | team_players_list | /teams/:id/players | FINAL |
| Team Setup | team_setup_cricket | /match/:id/team-setup | FINAL |
| Invite Teams | invite_teams_join_requests | /teams/:id/invite | FINAL |

---

# TOURNAMENTS

| Screen | Stitch Reference | Route | Status |
|---------|-----------------|-------|--------|
| Create Tournament | create_tournament | /tournaments/create | FINAL |
| Tournament Details | tournament_details | /tournaments/:id | FINAL |
| Tournament Fixtures | tournament_fixtures_schedule | /tournaments/:id/fixtures | FINAL |
| Tournament Standings | tournament_standings_points_table | /tournaments/:id/standings | FINAL |
| Tournament Bracket | tournament_bracket | /tournaments/:id/bracket | FINAL |
| Tournament Rankings | tournament_player_rankings | /tournaments/:id/rankings | FINAL |

---

# MATCH SETUP

| Screen | Stitch Reference | Route | Status |
|---------|-----------------|-------|--------|
| Create Match | create_match | /match/create | FINAL |
| Match Setup | match_setup_refined_overs_selection | /match/:id/setup | FINAL |
| Team Lineup | team_lineup_playing_xi | /match/:id/lineup | FINAL |
| Match Ready | match_ready | /match/:id/ready | FINAL |

---

# TOSS FLOW

| Screen | Stitch Reference | Route | Status |
|---------|-----------------|-------|--------|
| Toss Setup | toss_setup_refined_interactive_coin_result_state | /match/:id/toss/setup | FINAL |
| Digital Toss | digital_coin_toss | /match/:id/toss/flip | FINAL |
| Toss Result | toss_result | /match/:id/toss/result | FINAL |

---

# LIVE MATCH

| Screen | Stitch Reference | Route | Status |
|---------|-----------------|-------|--------|
| Live Match Scoring | live_match_scoring_interface | /match/:id/score | FINAL |
| Live Match Dashboard | live_match_dashboard_spectator_mode | /match/:id/live | FINAL |
| Match Events | match_events_feed | /match/:id/events | FINAL |
| Match Summary | match_summary_2 | /match/:id/summary | FINAL |

---

# SCORECARD

This is ONE reusable module.

It contains

• Batting

• Bowling

• Partnerships

• Fall of Wickets

These are NOT independent screens.

Parent

professional_full_scorecard_v2_screen_01

Child Tabs

full_scorecard_batting

full_scorecard_bowling

partnership_analytics

fall_of_wickets_analytics

Route

/match/:id/scorecard

---

# ANALYTICS

| Screen | Stitch Reference | Route | Status |
|---------|-----------------|-------|--------|
| Player Analytics | player_analytics_dashboard | /players/:id/analytics | FINAL |

---

# SHARED MULTI SPORT SCREENS

The following screens are reused for

Cricket

Football

Padel

• Splash

• Welcome

• Login

• Register

• Dashboard

• Search

• Notifications

• Profile

• Edit Profile

• Settings

• Team Details

• Team Players

• Tournament

• Fixtures

• Standings

• Brackets

• Rankings

• Match Ready

• Match Summary

---

# CRICKET ONLY

• Toss Flow

• Overs Setup

• Live Scoring

• Scorecards

• Partnerships

• Fall of Wickets

---

# FOOTBALL

Uses same UI

Different

Rules

Scoring

Statistics

Events

---

# PADEL

Uses same UI

Different

Rules

Scoring

Statistics

Events

---

# OBSOLETE

Never implement

Live Commentary

Old Splash Screens

Old Welcome Screens

Old Scorecards

Old Toss Screens

Old Match Setup

Old Analytics

Old Fixtures

Old Standings

---

# RULE

Only screens marked FINAL may be implemented.