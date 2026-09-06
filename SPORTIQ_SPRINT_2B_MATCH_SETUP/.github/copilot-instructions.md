# SPORTIQ Copilot Instructions

## Before UI Changes

- Before implementing or modifying any UI, read `DESIGN.md`.
- Treat `DESIGN.md` as the visual and interaction source of truth. Do not modify it unless explicitly requested.
- Inspect the existing architecture and the closest related feature before making changes.
- Do not assume routes, constructors, models, or parameters. Inspect their current definitions and usages first.
- When modifying a constructor or data model, inspect every usage and dependent route before editing.

## Architecture and Design

- Preserve the current Flutter, Dart, GoRouter, and Riverpod architecture.
- Do not randomly rewrite working code. Prefer the smallest production root-cause fix.
- Reuse `AppColors`, `AppSpacing`, `AppRadius`, `AppTypography`, and `AppTheme`.
- Reuse existing shared widgets before creating new UI components. Use `AppScaffold` and shared navigation/components where appropriate.
- Do not introduce arbitrary colors, spacing, radii, typography, or visual styles.
- New screens must look like part of the same SPORTIQ application.
- Cricket is the current reference implementation for UX quality and structure.
- Football and Padel inherit SPORTIQ's visual language but use their own sport-specific domain logic.
- Do not copy Cricket-specific concepts such as overs, wickets, striker, bowler, or cricket scoring controls into other sports.
- Preserve responsive behavior and safe areas.
- Maintain practical minimum touch targets and readable contrast.
- Do not introduce unnecessary packages.

## Tests and Validation

- Preserve existing tests unless a test is objectively incorrect.
- Never weaken tests just to make them pass.
- Keep `flutter analyze` at 0 issues and keep all `flutter test` tests passing.
- After substantial implementation work, run:

```text
 dart format .
 flutter analyze
 flutter test
```

## Conflict Handling

- If a request conflicts with `DESIGN.md` or the existing architecture, explain the conflict before introducing a new pattern.
- Do not modify existing application code, shared design tokens, or routing merely to avoid investigating the current implementation.
