# SPORTIQ

Multi-sport tournament & match management app (Cricket, Football, Padel).
Flutter + Riverpod + GoRouter + Supabase + Material 3, feature-first architecture.

## Status
Sprint 1 — Project Foundation complete. No features, auth, or backend logic implemented yet.
See `PROJECT_STATE.md` and `TODO.md`.

## Source of Truth
All architecture/design decisions come from `docs/`:
- SCREEN_MANIFEST.md
- DESIGN_RULES.md
- DESIGN_SYSTEM.md
- NAVIGATION_MAP.md
- DECISIONS.md
- POLISH_BACKLOG.md
- MVP_SCOPE.md

## Setup
1. `flutter pub get`
2. Copy `.env.example` to `.env` and fill in Supabase credentials.
3. Add `.env` to `pubspec.yaml` assets (kept out of assets by default so the
   project builds without secrets present) — or provide `--dart-define`
   values instead, per team convention.
4. `flutter run`

## Folder Structure
See `PROJECT_STATE.md` for the full structure and rationale.

## Architecture
- **Feature-first**: `lib/features/<feature>/{presentation,domain,data}`
- **Shared**: `lib/shared/{theme,widgets,models,repositories}` — reusable across features
- **Core**: `lib/core/{config,services,utils,extensions}` — app-wide infrastructure
- **App**: `lib/app/` — router, root widget, root providers

## Theming
All colors, spacing, radius, and typography are centralized in `lib/shared/theme/`.
Never hardcode a color or spacing value in a widget — reference `AppColors`,
`AppSpacing`, `AppRadius`, `AppTypography`, or the component-level Theme classes
set on `AppTheme.darkTheme`.
