// ignore_for_file: prefer_const_constructors, prefer_const_declarations, prefer_const_literals_to_create_immutables, require_trailing_commas

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/football_match_state.dart';

class FootballMatchEntryScreen extends StatelessWidget {
  const FootballMatchEntryScreen({super.key});
  @override
  Widget build(BuildContext context) => _SportShell(
      title: 'Football match',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        Text('Set up a football match',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.sm),
        const Text(
            'Choose squads, confirm the starting lineup, then take the match live.'),
        const SizedBox(height: AppSpacing.xl),
        const _TeamChoice(name: 'Falcons FC', label: 'Home team'),
        const SizedBox(height: AppSpacing.sm),
        const _TeamChoice(name: 'City United', label: 'Away team'),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
            label: 'Continue to lineup',
            onPressed: () => context.push('/football/match/lineup'))
      ]));
}

class FootballLineupScreen extends StatelessWidget {
  const FootballLineupScreen({super.key});
  @override
  Widget build(BuildContext context) => _SportShell(
      title: 'Starting lineup',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        Text('4-3-3 formation', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        const Text('Select the starting eleven and confirm the goalkeeper.'),
        const SizedBox(height: AppSpacing.lg),
        const _LineupRow(role: 'GK', player: 'Jordan Reed'),
        const _LineupRow(role: 'DEF', player: 'Alex Morgan'),
        const _LineupRow(role: 'MID', player: 'Maya Singh'),
        const _LineupRow(role: 'FWD', player: 'Taylor Khan'),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
            label: 'Ready for kickoff',
            onPressed: () => context.push('/football/match/live'))
      ]));
}

class FootballLiveScreen extends StatefulWidget {
  const FootballLiveScreen({super.key});
  @override
  State<FootballLiveScreen> createState() => _FootballLiveScreenState();
}

class _FootballLiveScreenState extends State<FootballLiveScreen> {
  FootballMatchState match =
      const FootballMatchState(homeTeam: 'Falcons FC', awayTeam: 'City United');
  void _update(FootballMatchState next) => setState(() => match = next);
  @override
  Widget build(BuildContext context) => _SportShell(
      title: 'Football live',
      actions: [
        AppBadge(
            label: match.isComplete ? 'FULL TIME' : 'LIVE',
            variant: AppBadgeVariant.success)
      ],
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        AppCard(
            child: Column(children: [
          Text('${match.minute}\'',
              style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
                child:
                    _ScoreTeam(name: match.homeTeam, score: match.homeGoals)),
            Text('—', style: Theme.of(context).textTheme.headlineMedium),
            Expanded(
                child: _ScoreTeam(name: match.awayTeam, score: match.awayGoals))
          ])
        ])),
        const SizedBox(height: AppSpacing.lg),
        Row(children: [
          Expanded(
              child: PrimaryButton(
                  label: 'Home goal',
                  onPressed: match.isComplete
                      ? null
                      : () => _update(match.goal(home: true)))),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
              child: SecondaryButton(
                  label: 'Away goal',
                  onPressed: match.isComplete
                      ? null
                      : () => _update(match.goal(home: false))))
        ]),
        const SizedBox(height: AppSpacing.sm),
        Row(children: [
          Expanded(
              child: SecondaryButton(
                  label: 'Yellow card',
                  onPressed: match.isComplete
                      ? null
                      : () => _update(match.card(match.homeTeam, 'Yellow')))),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
              child: SecondaryButton(
                  label: 'Advance minute',
                  onPressed:
                      match.isComplete ? null : () => _update(match.tick())))
        ]),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Match timeline',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          if (match.events.isEmpty)
            const Text('No events yet')
          else
            ...match.events.reversed.map(Text.new)
        ])),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
            label: 'End match',
            onPressed: match.isComplete
                ? () => context.push('/football/match/summary', extra: match)
                : () => _update(match.finish()))
      ]));
}

class FootballSummaryScreen extends StatelessWidget {
  const FootballSummaryScreen({required this.match, super.key});
  final FootballMatchState match;
  @override
  Widget build(BuildContext context) => _SportShell(
      title: 'Football summary',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        const AppBadge(label: 'COMPLETED', variant: AppBadgeVariant.success),
        const SizedBox(height: AppSpacing.md),
        AppCard(
            child: Column(children: [
          Text(match.homeTeam, style: Theme.of(context).textTheme.titleMedium),
          Text('${match.homeGoals}  —  ${match.awayGoals}',
              style: Theme.of(context).textTheme.displayMedium),
          Text(match.awayTeam, style: Theme.of(context).textTheme.titleMedium)
        ])),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
            label: 'Back to dashboard',
            onPressed: () => context.go('/dashboard'))
      ]));
}

class _SportShell extends StatelessWidget {
  const _SportShell({required this.title, required this.body, this.actions});
  final String title;
  final Widget body;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) => AppScaffold(
      appBar: SportiqAppBar(title: title, actions: actions), body: body);
}

class _TeamChoice extends StatelessWidget {
  const _TeamChoice({required this.name, required this.label});
  final String name;
  final String label;
  @override
  Widget build(BuildContext context) => AppCard(
      child: ListTile(
          leading: const AppAvatar(initials: 'FC'),
          title: Text(name),
          subtitle: Text(label),
          trailing: const Icon(Icons.chevron_right)));
}

class _LineupRow extends StatelessWidget {
  const _LineupRow({required this.role, required this.player});
  final String role;
  final String player;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
          child: ListTile(
              leading: AppBadge(label: role),
              title: Text(player),
              trailing: const Icon(Icons.check_circle,
                  color: AppColors.primaryFixedDim))));
}

class _ScoreTeam extends StatelessWidget {
  const _ScoreTeam({required this.name, required this.score});
  final String name;
  final int score;
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(name, textAlign: TextAlign.center),
        Text('$score', style: Theme.of(context).textTheme.displayLarge)
      ]);
}
