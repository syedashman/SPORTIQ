# PROJECT_STATE.md

## Sprint 1 REPAIR (this pass)

### Platform folders — BLOCKED, not fabricated
`android/`, `ios/`, `web/` are still **missing**. This tool environment has
no Flutter SDK and no network access to `pub.dev` / `storage.googleapis.com`
(only github/npm/pypi/crates domains are reachable), so `flutter create .`
could not be run. These folders were **not hand-written** — doing so risks
baking in wrong Gradle/AGP/Kotlin/Xcode versions and would misrepresent
real `flutter create` output as verified when it isn't. Run locally:
```
cd sportiq
flutter create . --project-name sportiq --org com.sportiq
```
This is safe to run on an existing project — it only adds missing platform
folders and does not overwrite `lib/`, `test/`, `docs/`, or `pubspec.yaml`
dependency entries (it may append a default `flutter:` block if absent,
but ours already exists).

### Fixed this pass
- **Fonts**: removed the `Inter`/`Geist` `fonts:` block from `pubspec.yaml`
  (files never existed). `AppTypography.bodyFontFamily` /
  `displayFontFamily` are now `null` (system font fallback); swapping in
  real fonts later only touches those two constants + pubspec.
- **Assets**: removed the `assets:` block from `pubspec.yaml` — the
  `assets/*` folders exist on disk but only contain `.gitkeep`, so nothing
  is declared until real files are added (avoids empty-folder build risk).
- **Env config**: `EnvConfig.load()` no longer requires `.env` to exist —
  missing file logs one warning and continues in "local foundation mode."
  Added `EnvConfig.isSupabaseConfigured` to detect empty/placeholder values.
- **Supabase**: `SupabaseConfig.initialize()` is now a no-op (one warning
  log) unless `isSupabaseConfigured` is true. `SupabaseConfig.client` must
  only be read after `isInitialized` is true.
- **Providers**: `supabaseClientProvider` is now `Provider<SupabaseClient?>`
  (nullable) plus a new `supabaseInitializedProvider`. No feature may
  depend on Supabase yet.
- **Connectivity**: replaced the bare stub with a documented
  `ConnectivityChecker` interface + `StubConnectivityChecker` impl, clearly
  labeled as temporary/fake in doc comments.
- **Router**: added the 8 previously-missing MVP routes (Complete Profile,
  Profile Reminder, Team Setup, Tournament Fixtures/Standings/Bracket/
  Rankings, Player Analytics) — all wired to the existing private
  `_PlaceholderScreen`, no real screens added.

### Still unverified (see "Remaining blockers" in chat response)
`flutter pub get`, `dart format .`, `flutter analyze`, `flutter test` could
not be executed in this environment — same SDK/network constraint as above.

## Sprint 1 — Project Foundation (original pass)

### What exists
- Flutter project skeleton (`pubspec.yaml`, `analysis_options.yaml`, `.gitignore`, `.env.example`)
- Feature-first folder structure under `lib/features/*` (auth, profile, dashboard,
  teams, tournaments, match_setup, cricket_scoring, live_spectator, scorecard, analytics)
  — structure only, no logic
- Centralized theme system (`lib/shared/theme/`): colors, typography, spacing,
  radius, and full ThemeData (buttons, inputs, cards, chips, nav bar, dialog,
  bottom sheet, app bar, dividers, badges)
- Core config: env loading (`EnvConfig`), Supabase bootstrap (`SupabaseConfig`)
- Core services: `AppLogger`, `ConnectivityService` (placeholder stream)
- Core utils: `Responsive` breakpoints, `BuildContext` extensions
- Riverpod root providers (`lib/app/providers.dart`)
- GoRouter route table matching `docs/NAVIGATION_MAP.md`, all routes point to
  a shared `_PlaceholderScreen` — no real screens built
- Reusable shared widgets: AppScaffold, SportiqAppBar, AppBottomNavigation,
  LoadingWidget, EmptyStateWidget, AppErrorWidget, OfflineWidget,
  PrimaryButton, SecondaryButton, AppTextField, SearchField, AppCard,
  AppAvatar, AppBadge, AppDialog, AppBottomSheet
- Asset folders: `assets/{fonts,icons,images,animations/lottie}` (empty, `.gitkeep`)
- Basic widget/unit tests for PrimaryButton, EmptyStateWidget, Responsive, and app boot

### What does NOT exist yet (by design — future sprints)
- Authentication logic/UI
- Backend/repository implementations (Supabase queries)
- Real screens for any feature (all routes are placeholders)
- Scoring logic (Cricket/Football/Padel)
- Tournament logic
- Match logic
- Profile logic
- Football/Padel sport-specific screens

### Environment / Tooling Constraint (read before next sprint)
This sandboxed build environment has **no Flutter SDK installed** and **no
network access to pub.dev / storage.googleapis.com** (only a small allowlist:
github.com, npm, pypi, crates.io, ubuntu archives). As a result:
- `flutter pub get`, `flutter analyze`, and `flutter test` could **not be
  executed** in this environment.
- All Dart files were hand-written and manually reviewed for syntax/import
  correctness, Riverpod/GoRouter API usage matching the pinned package
  versions, and Material 3 API correctness (e.g. `WidgetStateProperty`,
  `CardThemeData`, `DialogThemeData`).
- **Action required**: run `flutter pub get`, `flutter analyze`, and
  `flutter test` in a real Flutter environment before merging. See
  `TODO.md`.

## Next Sprint Candidates
- Sprint 2: Authentication screens (per MVP_SCOPE.md "Required for Launch")
- Sprint 3: Dashboard + Profile screens
- Sprint 4: Teams + Tournaments screens

## Sprint 2B — Core Match Entry & Cricket Setup

Implemented in this build:
- Choose Sport → Cricket → Match Entry
- Create Match / Join Match UI
- Create Teams
- Add Players (temporary player, invite/existing placeholders)
- Cricket match settings
- Digital toss setup
- Match Ready review
- Start Match routes to the existing live-scoring placeholder for Sprint 2C

