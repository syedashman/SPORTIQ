# SPORTIQ Design System

**Status:** Permanent visual and interaction reference for the current SPORTIQ Flutter implementation.

**Scope:** This document records the actual shared theme, reusable widgets, implemented screens, and recurring UI patterns in this repository. It also records known inconsistencies. It is a design reference, not a request to refactor existing screens.

**Source of truth:** `lib/shared/theme/`, `lib/shared/widgets/`, implemented feature screens, `docs/DESIGN_SYSTEM.md`, and `docs/DESIGN_RULES.md`. When this document says “token”, the value exists in code. When it says “intended”, the rule exists in documentation but may not yet be consistently implemented.

## 1. Brand Identity

SPORTIQ is a premium, multi-sport product for Cricket, Football, and Padel. The current visual foundation is a dark, high-contrast sports interface with an electric green action color. It is fast and information-dense without looking noisy: dark surfaces recede, white text establishes hierarchy, and green marks action, selection, progress, and success.

The visual direction combines the product intent described in `docs/DESIGN_SYSTEM.md` with patterns visible in the implemented onboarding, authentication, match setup, live scoring, summary, and scorecard flows:

- Dark charcoal and green-black backgrounds.
- Raised near-black cards with a very subtle white stroke.
- Bright white primary text and pale green secondary text.
- Electric green for the main action and selected state.
- Compact, rounded controls with generous touch targets.
- Strong emphasis on live status, scores, player identity, and next actions.
- Sport-specific content inside one shared visual language. Cricket owns the current reference implementation; Football and Padel should inherit its interaction quality and visual grammar, not its domain rules.

The intended type direction is Inter for UI/body text and Geist for display/headline text. Those fonts are not currently bundled, so the running application uses the platform default font.

## 2. Design Principles

1. **One SPORTIQ language across sports.** Change the data model and sport-specific semantics, not the core surfaces, spacing, hierarchy, or interaction patterns.
2. **Dark surfaces create focus.** Use the background for page-level space, raised surfaces for grouped content, and bright accents only for action or meaningful status.
3. **Scores and state are scannable.** Use strong hierarchy for score, match status, live indicators, and the current user action.
4. **Reuse before invention.** Consume `AppColors`, `AppSpacing`, `AppRadius`, `AppTypography`, `AppTheme`, and shared widgets before adding local styling.
5. **Touch targets are practical.** The documented minimum target is 48dp. The shared button theme uses a 48px minimum height.
6. **Keep actions predictable.** Primary actions are filled green pills; secondary actions are outlined; destructive or error states use the semantic error colors.
7. **Respect safe areas and content flow.** Use safe areas, leave space for sticky actions, and keep primary actions reachable.
8. **Prefer semantic states over decoration.** Green means active/success, red means error, blue means informational, and neutral surfaces carry passive content.
9. **Do not disguise technical debt as a variant.** If a screen bypasses shared components or uses a local value, preserve it only when matching that existing screen; do not spread the deviation.

## 3. Color System

All canonical colors are in `lib/shared/theme/app_colors.dart`. Use these tokens rather than new hex values.

### 3.1 Surfaces

| Token | Value | Use |
| --- | --- | --- |
| `AppColors.background` | `#0C1609` | Global dark green-black scaffold background and page-level canvas. |
| `AppColors.surface` | `#0E150B` | Theme surface and profile-style screen background. |
| `AppColors.surfaceDim` | `#0E150B` | Dim surface; currently the same value as `surface`. |
| `AppColors.surfaceBase` | `#0D0D0D` | Near-black base used by onboarding and splash compositions. |
| `AppColors.surfaceRaised` | `#171717` | Cards, inputs, dialogs, bottom sheets, and raised panels. |
| `AppColors.surfaceBright` | `#333B2F` | Brighter selected/neutral controls, chips, and status surfaces. |
| `AppColors.glassStroke` | `#14FFFFFF` | White at approximately 8% opacity; soft card/control border. |

### 3.2 Primary and accent colors

| Token | Value | Use |
| --- | --- | --- |
| `AppColors.primary` | `#FFFFFF` | Material primary token; currently white, not the green action color. |
| `AppColors.primaryContainer` | `#79FF5B` | Canonical electric-green accent; Material button, chip, selected, and success background. |
| `AppColors.primaryFixedDim` | `#5CE141` | Stronger/dimmer green used extensively by feature screens for actions, selections, progress, and branding. |
| `AppColors.onPrimaryContainer` | `#127500` | Foreground on the primary green container. |
| `AppColors.onPrimaryFixed` | `#022100` | Dark foreground for fixed green surfaces. |
| `AppColors.onPrimaryFixedVariant` | `#0A5300` | Alternate dark foreground on green. |

Use `primaryContainer` when following the shared Material theme. Match a screen’s established `primaryFixedDim` usage when extending that screen, but do not introduce a third green.

### 3.3 Text and semantic colors

| Token | Value | Use |
| --- | --- | --- |
| `AppColors.onBackground` | `#DDE5D4` | Primary text on dark backgrounds. |
| `AppColors.onSurfaceVariant` | `#BDCBB3` | Secondary text, hints, captions, and supporting content. |
| `AppColors.outline` | `#87957F` | Stronger outline and enabled/outlined control border. |
| `AppColors.secondary` | `#ABC7FF` | Informational blue accent and text-button foreground. |
| `AppColors.onSecondary` | `#002F65` | Foreground on secondary blue. |
| `AppColors.onSecondaryContainer` | `#F2F4FF` | Secondary-container foreground. |
| `AppColors.error` | `#FFB4AB` | Error background/icon/border and error badge. |
| `AppColors.onError` | `#690005` | Foreground on error. |
| `AppColors.onErrorContainer` | `#FFDAD6` | Error-container text. |
| `AppColors.tertiaryContainer` | `#FFDAD5` | Tertiary semantic container. |
| `AppColors.tertiaryFixedDim` | `#FFB4AB` | Tertiary fixed dim value; close to the error family. |

The theme also exposes inverse surface values: `#DDE5D4` and `#2B3327`. Avoid using inverse colors unless the component requires an inverse Material treatment.

### 3.4 Color usage rules

- Green is the primary action, active, selected, progress, and success signal.
- White/pale green is for readable content, not large decorative fills.
- Red is reserved for error, wicket/destructive confirmation, and failure states.
- Blue is informational and secondary, not a second primary brand color.
- Alpha variations of green and black are used in onboarding glow and ambient compositions. Keep them restrained.
- Existing feature screens contain some raw `Colors.white`, `Colors.black`, and inline colors. These are recorded as technical debt; new screens should use semantic tokens.

## 4. Surface Hierarchy

1. **Page canvas:** `AppColors.background` for normal dark screens; `AppColors.surfaceBase` for the more graphic onboarding/splash compositions.
2. **Theme surface:** `AppColors.surface` where a screen intentionally uses the Material surface token.
3. **Raised content:** `AppColors.surfaceRaised` for cards, text fields, dialogs, sheets, player panels, score panels, and review sections.
4. **Bright control surface:** `AppColors.surfaceBright` for neutral chips, selected control backgrounds in some variants, and contrast behind icons/text.
5. **Overlay:** dialogs and bottom sheets use `surfaceRaised`; bottom sheets have a 12px top radius and a visible drag handle.
6. **Glass treatment:** a low-contrast `glassStroke` border and occasional translucent raised panels are used in onboarding and match setup. Glow is an accent, not a general card shadow.

The global card theme has zero elevation, a 12px radius, and a `glassStroke` side. The design therefore relies on tonal contrast and strokes more than Material drop shadows.

## 5. Typography

The canonical text theme is in `lib/shared/theme/app_typography.dart` and is installed by `AppTheme.darkTheme`.

| Text role | Size | Weight | Color |
| --- | ---: | --- | --- |
| `displayLarge` | 40px | 800 | `onBackground` |
| `displayMedium` | 32px | 700 | `onBackground` |
| `headlineLarge` | 28px | 700 | `onBackground` |
| `headlineMedium` | 24px | 600 | `onBackground` |
| `titleLarge` | 20px | 800 | `onBackground` |
| `titleMedium` | 16px | 700 | `onBackground` |
| `bodyLarge` | 16px | 400 | `onBackground` |
| `bodyMedium` | 14px | 400 | `onSurfaceVariant` |
| `labelLarge` | 14px | 700 | `onBackground` |
| `labelMedium` | 12px | 600 | `onSurfaceVariant` |

Rules:

- Use the theme text styles rather than local `fontSize` values.
- Display/headline styles are intended for large screen or marketing-style titles; card and control titles should remain compact.
- Do not use italic headings.
- Keep score values and key match numbers visually stronger than explanatory text; use the nearest existing display/headline style instead of inventing a new scale.
- `AppBarTheme` uses `titleLarge`, left aligned, with zero elevation.
- The intended families are `Inter` and `Geist`, but `bodyFontFamily` and `displayFontFamily` are currently `null`; the current runtime falls back to the platform font. Do not claim the bundled app currently renders Inter/Geist.

## 6. Spacing System

`lib/shared/theme/app_spacing.dart` defines the intended 8px base system:

| Token | Value |
| --- | ---: |
| `AppSpacing.xs` | 4px |
| `AppSpacing.sm` | 8px |
| `AppSpacing.md` | 16px |
| `AppSpacing.lg` | 24px |
| `AppSpacing.xl` | 32px |
| `AppSpacing.xxl` | 40px |
| `AppSpacing.xxxl` | 48px |

The project documentation also describes 64px as a permitted layout value, and `Responsive.horizontalPadding` returns 64px for desktop, but there is no `AppSpacing` token for 64px.

Observed layout rules:

- Most auth/onboarding screens use 24px horizontal padding (`AppSpacing.lg`).
- Shared cards default to 16px internal padding (`AppSpacing.md`).
- Empty/error states use 24px outer padding.
- Buttons use 24px horizontal padding and a 48px minimum height.
- Inputs use 16px horizontal and vertical content padding.
- Section gaps commonly use 8, 16, and 24px.
- Setup flows use a centered content column with a 640px maximum width.
- New screens should use tokens; existing raw values are documented under technical debt rather than normalized here.

## 7. Border Radius

`lib/shared/theme/app_radius.dart` is authoritative for reusable components:

| Token | Value | Typical use |
| --- | ---: | --- |
| `AppRadius.xs` / `xsRadius` | 4px | Small/default detail radius. |
| `AppRadius.sm` / `smRadius` | 8px | Compact controls and setup selections. |
| `AppRadius.md` / `mdRadius` | 12px | Cards, inputs, dialogs, sheets, and grouped panels. |
| `AppRadius.full` / `fullRadius` | 9999px | Buttons, chips, badges, and pill controls. |

The source design documentation mentions a 16px “large” radius, but no 16px token exists. Do not add a new radius casually; use 12px for the established card/input family and full radius for pills.

## 8. Borders, Shadows & Effects

- Cards use a 1px `glassStroke` border through `CardTheme`.
- Inputs use `outline` for the stronger base border, `glassStroke` for enabled border, a 2px `primaryContainer` focused border, and `error` for error border.
- Dividers are 1px with `glassStroke` and 16px theme spacing.
- Material cards and app bars use zero elevation. Tonal layering and borders provide separation.
- Onboarding and splash use restrained electric-green ambient gradients, alpha overlays, and glow-like effects over `surfaceBase`.
- Match setup uses subtle translucent green panels and progress/highlight treatments.
- Avoid general-purpose neon, heavy shadows, or glow around every component. Glow belongs to brand/entry moments and live emphasis.
- Existing code includes local shadows, alpha overlays, and raw colors in onboarding and feature screens. Extend those treatments only when the new UI is clearly the same variant.

## 9. Buttons

### Shared variants

`PrimaryButton` (`lib/shared/widgets/buttons/primary_button.dart`) wraps `ElevatedButton` and uses `ElevatedButtonTheme`:

- Full width by default; `expand: false` preserves intrinsic width.
- Electric-green `primaryContainer` background.
- `onPrimaryContainer` foreground.
- 48px minimum height.
- 24px horizontal padding.
- Full-pill radius.
- `labelLarge` text.
- Optional 18px icon with an 8px gap.
- `isLoading` replaces the label with a 20px circular progress indicator with 2px stroke and disables the action.

`SecondaryButton` (`lib/shared/widgets/buttons/secondary_button.dart`) wraps `OutlinedButton`:

- Full width by default, optional intrinsic width.
- `onBackground` foreground.
- 48px minimum height and 24px horizontal padding.
- `outline` border.
- Full-pill radius.
- Optional 18px icon with an 8px gap.

The theme also defines `TextButton` with `secondary` blue foreground. Use it for lower-emphasis links or secondary actions.

### States

All button types must preserve Material pressed, focused, disabled, and enabled behavior. Loading disables `PrimaryButton`. Disabled colors come from Material theme resolution; do not create one-off disabled fills. Danger and success actions should use semantic error/green treatments while keeping the same geometry.

Use filled green for the single most important next action. Use outlined for an alternate or cancel path. Keep button labels concise and action-oriented.

## 10. Inputs & Selection Controls

`InputDecorationTheme` provides the standard field language:

- Filled `surfaceRaised` background.
- 16px horizontal/vertical content padding.
- 12px radius.
- `outline` border for base treatment.
- `glassStroke` enabled border.
- 2px electric-green focused border.
- `error` error border.
- Body-medium hint and label styles.

`AppTextField` supports label, hint, validation error, password obscuring, keyboard type, enabled/disabled state, suffix icon, controller, and `onChanged`. `SearchField` adds a search icon and search keyboard action with change/submit callbacks.

Selection patterns visible in the implemented flows include:

- Sport selection cards with a stronger selected surface/accent.
- Chips and segmented controls for compact options such as balls per over and player selection.
- Checkboxes in profile completion using green selected color.
- A native `DropdownButton` in `CricketSettingsScreen`; this is an observed exception to the documented custom-bottom-sheet rule.
- Bottom-sheet selection for replacement players and match transitions in live scoring.

Use labels, helper/error text, and password visibility controls where relevant. New dropdown-like controls should use `AppBottomSheet` or a custom control consistent with the sheet theme rather than introducing another native dropdown.

## 11. Cards

The default reusable card is `AppCard` (`lib/shared/widgets/surfaces/app_card.dart`):

- Material `CardTheme` surface: `surfaceRaised`.
- Zero elevation.
- 12px radius.
- 1px glass stroke.
- 16px default padding.
- Optional tap behavior through `InkWell` with the same 12px radius.

Observed card families:

- **Selection cards:** sport, team, player, or option cards; selected state uses green or brighter surface treatment and a clear check/active affordance.
- **Summary/review cards:** grouped match facts with compact title/value rows.
- **Player cards:** avatar/initials, name, role/status, and selection state.
- **Score cards:** innings/score blocks with a stronger green or white score hierarchy.
- **Stat cards:** compact numeric value plus label; keep the value dominant and supporting label secondary.
- **Live cards:** current striker/non-striker/bowler and current-over context, with live status clearly visible.

Do not create nested decorative cards for every section. Use a raised card when it genuinely groups information or creates a tappable unit.

## 12. Navigation

### App shell

`lib/app/app.dart` uses `MaterialApp.router`, `AppTheme.darkTheme`, `ThemeMode.dark`, and `GoRouter`. The initial location is `/splash`; the debug banner is disabled.

`AppScaffold` provides a safe-area body plus optional `SportiqAppBar`, `AppBottomNavigation`, floating action button, and sticky bottom action. Its sticky action is layered at the bottom with a second bottom safe area so it does not overlap content. Prefer it for new standard screens.

`SportiqAppBar` wraps `AppBar`, uses the global app bar theme, defaults to a left-aligned title, and accepts an optional leading widget and actions.

`AppBottomNavigation` is a routing-agnostic wrapper around `NavigationBar`. The theme uses:

- `surfaceRaised` background.
- `primaryContainer` selected indicator.
- `labelMedium` labels.
- 64px height.

Live scoring has its own bottom navigation for Score, Scorecard, and Settings. The shared component is available for future app-level destinations.

### Routing and implemented screens

GoRouter currently maps the following real screens:

- `/splash` -> `SplashScreen`
- `/welcome` -> `WelcomeScreen`
- `/get-started` -> `GetStartedScreen`
- `/choose-sport` -> `ChooseSportScreen`
- `/login` -> `LoginScreen`
- `/signup` -> `CreateAccountOptionsScreen`
- `/signup/email` -> `EmailSignupScreen`
- `/forgot-password` -> `ForgotPasswordScreen`
- `/reset-link-sent` -> `ResetLinkSentScreen`
- `/verify-email` -> `VerifyEmailScreen`
- `/account-created` -> `AccountCreatedScreen`
- `/profile/complete` -> `CompleteProfileScreen`
- `/match/entry` -> `MatchEntryScreen`
- `/match/create/teams` -> `CreateTeamsScreen`
- `/match/create/players` -> `AddPlayersScreen`
- `/match/create/settings` -> `CricketSettingsScreen`
- `/match/create/toss` -> `TossSetupScreen`
- `/match/create/ready` -> `MatchReadyScreen`
- `/match/create/opening-players` -> `OpeningPlayersScreen`
- `/match/demo/score` and `/match/:id/score` -> `LiveScoringScreen`
- `/match/:id/summary` -> `MatchSummaryScreen`
- `/match/:id/scorecard` -> `ScorecardScreen`

The router also contains placeholder routes for dashboard, profile, settings, notifications, search, teams, tournaments, live match, events, and player analytics. A placeholder route is not an implemented design reference.

## 13. Sports Components

The current sports UI is Cricket-led. Football and Padel should reuse these structural patterns where their domain makes sense, while changing the data and terminology.

### Team cards

Team creation and review screens establish a team-first flow. Team cards should make the team name and identity obvious, use a raised surface, keep metadata secondary, and expose a clear selected/edit/remove action when relevant.

### Player cards and selection

Player setup and opening-player screens use compact raised panels with identity, role, and selection feedback. Use `AppAvatar` for a 40px default circular image/initials fallback. Selected players use green accent/surface treatment; unselected players use raised/bright neutral surfaces and the glass stroke.

### Match cards and review

The match setup flow progresses from entry to teams, players, settings, toss, ready/review, and opening players. Review surfaces group teams, overs, players per side, balls per over, toss winner, decision, batting team, bowling team, and lineups. Keep the next action sticky or visually obvious and preserve the flow’s single-step progression.

### Scoreboards and live scoring

`LiveScoringScreen` establishes the primary live-match pattern:

- Header with innings score and run-rate information.
- Current striker, non-striker, and bowler cards.
- Current-over event strip.
- Large run controls for `0`, `1`, `2`, `3`, `4`, and `6`.
- Wicket action.
- Extras for Wide, No Ball, Bye, and Leg Bye.
- Undo last event.
- End-innings/end-match confirmation.
- Bottom sheets for player changes after wickets, overs, and innings transitions.
- Score, Scorecard, and Settings navigation.

Score controls must make the current action obvious, remain large enough to operate during live play, and maintain a visible distinction between legal ball events, extras, wickets, and undo.

### Scorecard and statistics

`ScorecardScreen` uses a tabbed innings view with:

- Batting table: batter, runs, balls, fours, sixes, strike rate.
- Bowling table: bowler, overs, runs, wickets, wides, no-balls, economy.
- Innings details: extras, boundaries, run rate, balls per over, bowling team.
- Ball-by-ball event list.

The current tables have minimum widths of approximately 680px and 690px and use horizontal scrolling. This is an implementation exception to the no-horizontal-scroll design rule and is recorded below; future responsive tables should resolve the conflict deliberately.

### Live indicators and match status

Use `AppBadge` for status/role pills. Variants are:

- `neutral`: `surfaceBright` background and `onBackground` foreground.
- `success`: `primaryContainer` background and `onPrimaryContainer` foreground.
- `error`: `error` background and `onError` foreground.
- `info`: `secondary` background and `onSecondary` foreground.

Use explicit live, upcoming, completed, winner, captain, organizer, scorer, or official labels where the domain requires them. Live state should use green emphasis plus readable text; do not rely on color alone.

### Match summary

`MatchSummaryScreen` supports winner/in-progress state, innings score cards, a Player of the Match placeholder, a full scorecard action, and a back-to-sports action. The summary is a conclusion surface: score and outcome dominate, while details remain available through the scorecard.

## 14. Screen Layout Rules

- Use a safe area around content and system UI. `AppScaffold` is the preferred standard shell.
- On phone-sized auth and setup screens, begin with 24px horizontal padding unless the existing screen variant clearly establishes another token-backed layout.
- Use 16px for card internals and common control gaps; 24px for section-level separation; 32px and above for major visual breaks.
- Use vertical scrolling for content-heavy screens. Do not let sticky actions cover scrollable content; add bottom space or use `AppScaffold.stickyBottomAction`.
- `SetupScaffold` constrains setup content to 640px and uses a scrollable column. New setup-like flows should retain that focused reading width.
- Keep one clear content hierarchy: page title, supporting context, grouped content, then the next action.
- Keep primary CTAs near the bottom of a completed step or in the sticky action area, with enough bottom safe-area space.
- Do not hardcode arbitrary screen widths. Use constraints, available width, and responsive helpers.
- Use horizontal scrolling only where the current implementation has a documented exception (scorecard tables/current-over strip); do not copy that exception into ordinary cards or forms.
- Preserve readable contrast and minimum 48dp interactive targets.

## 15. Responsive Design

`lib/core/utils/responsive.dart` defines:

- Mobile: width `< 600`.
- Tablet: width `600` through `< 1024`.
- Desktop: width `>= 1024`.
- Horizontal padding: 16px mobile, 32px tablet, 64px desktop.

Observed adaptations:

- `SetupScaffold` caps content at 640px rather than stretching setup forms across large screens.
- `CricketSettingsScreen` changes setting cards to a vertical layout below 430px.
- `LiveScoringScreen` uses three score-button columns below 360px and four columns at wider widths.
- Onboarding checks compact height below 720px and reduces selected vertical gaps.
- Most current feature screens are phone-first; the responsive helper is tested but not broadly consumed.
- Tablet behavior is explicitly a later refinement in `responsive.dart` and `docs/DESIGN_RULES.md`; new tablet layouts should avoid assuming desktop completeness.

For new screens:

- Small phones: preserve 16px side padding, stack controls, reduce optional decorative spacing, and keep score/actions visible without clipping.
- Standard/large phones: use the normal token spacing and two-column only where the content remains legible.
- Tablets: use 32px side padding and bounded content columns; let dense data use intentional table layouts.
- Large widths: use 64px outer padding and a max-width content region; do not scale typography with viewport width.

## 16. Interaction & State Design

- **Selected:** electric-green accent, selected indicator, brighter surface, or checkmark. Keep text readable using the matching `onPrimaryContainer`/dark foreground.
- **Pressed:** use Material ink/state behavior; preserve the control’s shape and semantic color.
- **Focused:** inputs use a 2px green border; other controls should retain a visible Material focus treatment.
- **Disabled:** use Material disabled resolution and prevent interaction. Do not simulate disabled state only by lowering opacity.
- **Loading:** use `LoadingWidget` for screen/data loading; `PrimaryButton.isLoading` for an in-flight CTA. The current loading spinner is green.
- **Success:** use green container/badge and green emphasis, not a new color.
- **Error:** use error red/pink tokens for icon, border, badge, and validation. `AppErrorWidget` includes a retry action.
- **Warning:** no dedicated warning token currently exists. Use a neutral or existing semantic treatment until a canonical warning token is added; do not invent orange in one screen.
- **Live:** combine a green live indicator/label with current score/context. Do not rely on a green dot without accessible text.
- **Completed:** use neutral or success badge semantics with outcome text.
- **Empty:** use `EmptyStateWidget` with a 48px icon, centered title, optional message, and optional action.
- **Offline:** use `OfflineWidget`, a full-width `surfaceBright` banner with wifi-off icon, message, and optional Retry text button.
- **Error retry:** use `AppErrorWidget`; its standard icon is 48px and its retry action is a `PrimaryButton`.
- **Dialogs:** use `AppDialog.confirm` and the shared `DialogTheme` for confirmations rather than raw local dialogs.
- **Bottom sheets:** use `AppBottomSheet`; the global sheet is raised, rounded at the top, scroll-controlled by default, and shows a drag handle.

## 17. Animation & Motion

Motion is purposeful and currently local to the flow rather than a formal animation system:

- `SplashScreen`: 1800ms entrance, 2600ms repeating glow, navigation after 3200ms.
- `WelcomeScreen`: 1100ms entrance and 4200ms ambient loop.
- `GetStartedScreen`: page transition with a `PageController`, 420ms transition, and scale/opacity interpolation.
- `TossSetupScreen`: 1500ms coin animation with a 10π rotation and scale sequence peaking around 1.16, dropping to 0.92, then returning to 1.
- Opening-player selection: `AnimatedContainer` around 180ms.
- Toss decision content: `AnimatedSwitcher` around 320ms.

Future animations should be short, support comprehension, avoid blocking live input, and match these existing patterns. Do not add a global animation framework or decorative motion without a product need.

## 18. Reusable Components

All shared widgets are exported by `lib/shared/widgets/widgets.dart`.

| Component | File | Purpose and reuse |
| --- | --- | --- |
| `AppScaffold` | `lib/shared/widgets/app_scaffold.dart` | Safe-area shell, optional app bar/navigation/FAB, and non-overlapping sticky bottom action. Use for new standard screens. |
| `SportiqAppBar` | `lib/shared/widgets/app_bar.dart` | Shared Material app bar with title, leading widget, actions, and left-aligned default. |
| `AppBottomNavigation` | `lib/shared/widgets/app_bottom_navigation.dart` | Injected `NavigationBar` destinations and selected index; routing remains outside. |
| `PrimaryButton` | `lib/shared/widgets/buttons/primary_button.dart` | Filled primary CTA, optional icon, full-width option, and loading state. |
| `SecondaryButton` | `lib/shared/widgets/buttons/secondary_button.dart` | Outlined secondary/cancel action, optional icon, full-width option. |
| `AppTextField` | `lib/shared/widgets/inputs/app_text_field.dart` | Standard labeled/hinted/validated/password-capable text input. |
| `SearchField` | `lib/shared/widgets/inputs/search_field.dart` | Search input with icon and search keyboard action for future dashboard/team/tournament surfaces. |
| `AppBottomSheet` | `lib/shared/widgets/overlays/app_bottom_sheet.dart` | Standard scroll-controlled modal sheet for pickers, filters, and role assignment. |
| `AppDialog` | `lib/shared/widgets/overlays/app_dialog.dart` | Standard confirm/cancel dialog using theme surfaces and actions. |
| `EmptyStateWidget` | `lib/shared/widgets/states/empty_state_widget.dart` | Centered empty state with icon, title, optional message, and action. |
| `AppErrorWidget` | `lib/shared/widgets/states/error_widget.dart` | Centered error state with error icon, message, and optional Retry CTA. |
| `LoadingWidget` | `lib/shared/widgets/states/loading_widget.dart` | Centered green spinner with optional message. |
| `OfflineWidget` | `lib/shared/widgets/states/offline_widget.dart` | Full-width offline banner with retry. |
| `AppAvatar` | `lib/shared/widgets/surfaces/app_avatar.dart` | Circular network avatar with initials fallback; 40px default size. |
| `AppBadge` | `lib/shared/widgets/surfaces/app_badge.dart` | Neutral, success, error, and info pill status/role badge. |
| `AppCard` | `lib/shared/widgets/surfaces/app_card.dart` | Raised, bordered, 12px card with 16px default padding and optional tap. |
| `SetupScaffold` | `lib/features/match_setup/presentation/widgets/setup_scaffold.dart` | Match setup-specific scroll shell and bounded content/progress treatment. Reuse for setup steps, not generic dashboard pages. |

Feature-level reusable/domain surfaces also include the Cricket scoring state/controller patterns, match setup data passed through GoRouter extras, and scorecard table/summary structures. Search the feature `presentation/widgets` folders before making another player, score, or setup component.

## 19. Cricket Reference Patterns

Cricket is the current reference implementation for the SPORTIQ experience because it is the only sport with a complete setup-to-live-to-summary-to-scorecard path.

Reference flow:

1. `MatchEntryScreen` establishes entry into a focused creation flow.
2. `CreateTeamsScreen` establishes team identity and validation.
3. `AddPlayersScreen` establishes player creation, editing, duplicate detection, and selection.
4. `CricketSettingsScreen` establishes numeric settings, players per side, and five/six-ball choice.
5. `TossSetupScreen` establishes a visually meaningful transition with animation and decision selection.
6. `MatchReadyScreen` establishes review, confirmation, and the final setup CTA.
7. `OpeningPlayersScreen` establishes role assignment for striker, non-striker, and bowler.
8. `LiveScoringScreen` establishes the high-frequency live interaction pattern, event history, undo, score controls, replacement sheets, and live navigation.
9. `ScorecardScreen` establishes dense statistics and ball-by-ball detail.
10. `MatchSummaryScreen` establishes outcome and post-match actions.

Football and Padel should inherit the following reusable UX philosophy:

- A guided setup sequence with clear review before starting.
- Strong team/player identity surfaces.
- A live view that makes current state and primary action immediately scannable.
- Dense statistics separated from the live action surface.
- Summary/outcome screens that connect back to detailed records.

They must not copy Cricket-specific concepts such as overs, balls, toss, striker, bowler, wickets, or cricket score controls into their own domain logic.

## 20. Rules for Future Screens

1. Read `DESIGN.md` before implementing UI.
2. Reuse `AppTheme`, `AppColors`, `AppSpacing`, `AppRadius`, and `AppTypography` before introducing local values.
3. Never introduce an arbitrary color when a semantic token exists.
4. Never introduce arbitrary spacing when an `AppSpacing` token provides the needed value.
5. Never introduce arbitrary radius values when `AppRadius` provides the required geometry.
6. Use theme text styles instead of one-off font sizes and weights.
7. Reuse shared widgets before creating a duplicate button, card, input, badge, state, dialog, sheet, or navigation shell.
8. Use `AppScaffold`/`SportiqAppBar`/`AppBottomNavigation` for new standard shells unless the screen is a documented special variant.
9. Keep the dark surface hierarchy, white/pale-green text hierarchy, electric green action language, and subtle glass stroke.
10. Preserve 48dp touch targets and readable contrast.
11. Keep primary CTA placement predictable and safe-area aware.
12. Preserve responsive behavior for small phones, standard phones, large phones, and bounded tablet layouts.
13. Prefer vertical scrolling. Treat existing horizontal table/current-over scrolling as a known exception requiring deliberate review.
14. Use bottom sheets for dropdown-like selection rather than default native dropdowns.
15. Keep live workflows fast and undoable; do not bury high-frequency actions in menus.
16. Keep sport-specific domain logic out of shared visual components.
17. Do not redesign an existing shared component solely to accommodate one new screen.
18. Avoid unnecessary dependencies and preserve the existing Flutter/Material 3 approach.
19. Support loading, empty, offline, retry, error, selected, disabled, and completed states where the screen has data or interaction.
20. Use accessible labels and do not communicate important state by color alone.
21. Run focused tests and inspect responsive layouts before considering a new screen complete.

## 21. Anti-Patterns

Do not:

- Add random hardcoded colors or inline hex values.
- Scatter raw `EdgeInsets` values when a spacing token exists.
- Add arbitrary `BorderRadius.circular(...)` values when a radius token exists.
- Use default Material widgets that visibly conflict with the dark SPORTIQ theme.
- Duplicate shared buttons, cards, fields, dialogs, sheets, badges, or state widgets.
- Create a different visual system for Football or Padel.
- Use excessive neon, glow, elevation, or decorative gradients.
- Use placeholder player/team data when real data is already available.
- Make a score, live indicator, or winner state depend on color alone.
- Put sticky actions over content or ignore bottom/system insets.
- Introduce horizontal scrolling for ordinary cards and forms.
- Use a native dropdown for a new picker without a deliberate documented reason.
- Copy Cricket-specific functionality into another sport.
- Treat a route placeholder as an implemented visual reference.
- Add a new font family, icon pack, or package without a product and design-system reason.

## 22. Existing Design Inconsistencies / Technical Debt

These are observations from the current implementation. They are intentionally documented, not silently standardized or fixed by this file.

1. **Primary token ambiguity:** `AppColors.primary` is white, while the documented primary accent is electric green. Feature screens use both `primaryContainer` (`#79FF5B`) and `primaryFixedDim` (`#5CE141`) for primary-looking actions.
2. **Fonts are not bundled:** the intended Inter and Geist families are documented, but both typography family constants are `null`, so runtime rendering uses the platform default.
3. **Raw color usage remains:** several feature screens use `Colors.white`, `Colors.black`, `Colors.black87`, and inline `Color(0x...)` values despite the centralized-token rule. Onboarding contains intentionally local ambient gradient colors; live scoring, player setup, and scorecard also have local black/white decisions.
4. **Shared shell adoption is incomplete:** many implemented feature screens use raw `Scaffold`, `AppBar`, `showDialog`, `showModalBottomSheet`, or `NavigationBar` even though `AppScaffold`, `SportiqAppBar`, `AppDialog`, `AppBottomSheet`, and `AppBottomNavigation` exist.
5. **Spacing is not fully tokenized:** the documented system permits 64px, but `AppSpacing` stops at 48px. Feature screens also contain local values such as 2, 5, 10, 11, 12, 14, 18, 20, 28, 30, 42, 52, and 64.
6. **Radius coverage is incomplete:** docs describe 16px large radius, but `AppRadius` contains only 4, 8, 12, and full. Feature screens use local 20px, 24px, 28px, 42px, 100px, and similar values for special visuals.
7. **Typography drift:** onboarding and feature screens contain local sizes including 7, 9, 10, 11, 12, 15, 22, 28, 29, and 34px despite the single type-scale rule. Some may be intentional logo/hero treatments, but they are not centralized variants.
8. **Horizontal-scroll conflict:** `docs/DESIGN_RULES.md` says tables and filters must not require horizontal scrolling, while the scorecard uses minimum-width tables around 680/690px and horizontal scrolling; the live current-over strip also scrolls horizontally.
9. **Native dropdown exception:** `CricketSettingsScreen` uses `DropdownButton`, while the documented interaction rule calls for a custom dropdown or bottom sheet.
10. **Placeholder route coverage:** the route table includes many post-auth, teams, tournament, analytics, live spectator, and event destinations that render `_PlaceholderScreen`. `docs/SCREEN_MANIFEST.md` marks some of those areas as final, so the manifest and runtime implementation disagree.
11. **Feature completeness is uneven:** Football and Padel selection currently surface a snackbar rather than a full flow. Authentication, persistence, backend actions, and several post-auth destinations are UI-only or placeholders.
12. **State ownership varies:** most flows use local `StatefulWidget` state and `setState`; Riverpod is wired at app boot but is not visibly used by these UI flows. Toss randomness is locally generated in `TossSetupScreen`.
13. **Profile flow is incomplete:** `CompleteProfileScreen` routes to choose-sport without validating or persisting all profile selections.
14. **Documentation lag:** `TODO.md` still lists several areas as unfinished even though partial UI and tests now exist.
15. **Test coverage follows implemented slices:** onboarding/auth, match setup, scoring, scorecard, button behavior, empty state, boot, and responsive classification are covered. There are no visible tests for placeholder routes, app-shell consistency, accessibility, tablet layouts, overflow behavior, or backend-connected states.

These inconsistencies are part of the current project record. New work should follow the rules above and should not widen any inconsistency without documenting why.

## 23. Reference Files

Theme and tokens:

- `lib/shared/theme/app_colors.dart`
- `lib/shared/theme/app_spacing.dart`
- `lib/shared/theme/app_radius.dart`
- `lib/shared/theme/app_typography.dart`
- `lib/shared/theme/app_theme.dart`
- `lib/shared/theme/theme.dart`

Shared widgets:

- `lib/shared/widgets/widgets.dart`
- `lib/shared/widgets/app_scaffold.dart`
- `lib/shared/widgets/app_bar.dart`
- `lib/shared/widgets/app_bottom_navigation.dart`
- `lib/shared/widgets/buttons/primary_button.dart`
- `lib/shared/widgets/buttons/secondary_button.dart`
- `lib/shared/widgets/inputs/app_text_field.dart`
- `lib/shared/widgets/inputs/search_field.dart`
- `lib/shared/widgets/overlays/app_dialog.dart`
- `lib/shared/widgets/overlays/app_bottom_sheet.dart`
- `lib/shared/widgets/surfaces/app_card.dart`
- `lib/shared/widgets/surfaces/app_badge.dart`
- `lib/shared/widgets/surfaces/app_avatar.dart`
- `lib/shared/widgets/states/loading_widget.dart`
- `lib/shared/widgets/states/empty_state_widget.dart`
- `lib/shared/widgets/states/error_widget.dart`
- `lib/shared/widgets/states/offline_widget.dart`

Flow and responsive references:

- `lib/core/utils/responsive.dart`
- `lib/features/match_setup/presentation/widgets/setup_scaffold.dart`
- `lib/features/cricket_scoring/presentation/screens/live_scoring_screen.dart`
- `lib/features/cricket_scoring/presentation/screens/match_summary_screen.dart`
- `lib/features/scorecard/presentation/screens/scorecard_screen.dart`
- `lib/app/app.dart`
- `lib/app/app_router.dart`
- `docs/DESIGN_SYSTEM.md`
- `docs/DESIGN_RULES.md`
- `docs/SCREEN_MANIFEST.md`
- `docs/NAVIGATION_MAP.md`
- `docs/POLISH_BACKLOG.md`
- `TODO.md`
