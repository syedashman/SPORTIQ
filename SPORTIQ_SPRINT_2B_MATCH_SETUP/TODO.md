# TODO.md

## Immediate (before Sprint 2 starts) — run locally in order
- [ ] `cd sportiq && flutter create . --project-name sportiq --org com.sportiq`
      — generates missing `android/`, `ios/`, `web/` folders. Safe on an
      existing project; does not overwrite `lib/`, `test/`, `docs/`.
- [ ] `flutter pub get` — dependency resolution is still **unverified**
      (no pub.dev access in the repair environment).
- [ ] `dart format .`
- [ ] `flutter analyze` — fix any errors/warnings surfaced (manual review
      was done in the repair pass; a real analyzer pass is required).
- [ ] `flutter test` — confirm all 4 existing tests pass.
- [ ] Add approved Inter/Geist font files to `assets/fonts/`, then restore
      the `fonts:` block in `pubspec.yaml` and set `bodyFontFamily` /
      `displayFontFamily` in `app_typography.dart` back to their real names.
- [ ] Add real icon/image/lottie files, then re-add the corresponding
      `assets:` paths in `pubspec.yaml`.
- [ ] Create local `.env` from `.env.example` with real Supabase project
      credentials; decide team convention (bundled asset vs. `--dart-define`)
      and update `pubspec.yaml` + `EnvConfig` accordingly.
- [ ] Replace `StubConnectivityChecker` with a `connectivity_plus`-backed
      implementation once package installation is available.
- [ ] Confirm exact Material 3 type-scale values with design (marked
      "verify during implementation" in `docs/DESIGN_SYSTEM.md`).
- [ ] Confirm tablet responsive breakpoints/layout rules with design.

## Sprint 2+ (feature work — out of scope for Sprint 1)
- [ ] Implement Authentication screens + logic
- [ ] Implement Supabase repositories per feature
- [ ] Replace GoRouter placeholder screens feature-by-feature
- [ ] Implement Dashboard, Profile, Teams, Tournaments, Match Setup screens
- [ ] Implement Cricket scoring logic and screens
- [ ] Implement Full Scorecard module (tabbed: batting/bowling/partnerships/fow)
- [ ] Implement reusable role assignment UI inside Create Match flow
      (Officials/Scorer/Commentator — all optional, per DECISIONS.md)
- [ ] Implement organizer invite inside Create Tournament flow
- [ ] Football/Padel sport-specific match setup, scoring, scorecard (post-MVP)
- [ ] Work through `docs/POLISH_BACKLOG.md` items after core flows are functional
