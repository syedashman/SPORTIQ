// ignore_for_file: prefer_const_constructors, prefer_const_declarations, prefer_const_literals_to_create_immutables, require_trailing_commas

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/padel_match_state.dart';

class PadelMatchEntryScreen extends StatelessWidget {
  const PadelMatchEntryScreen({super.key});
  @override
  Widget build(BuildContext context) => _PadelShell(
      title: 'Padel match',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        Text('Set up a padel match',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.sm),
        const Text(
            'Build your pairings, choose the server and start a best-of-three match.'),
        const SizedBox(height: AppSpacing.xl),
        const _PairCard(label: 'Pair A', players: 'Maya Singh  +  Alex Morgan'),
        const SizedBox(height: AppSpacing.sm),
        const _PairCard(
            label: 'Pair B', players: 'Jordan Reed  +  Taylor Khan'),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
            label: 'Continue to match ready',
            onPressed: () => context.push('/padel/match/ready'))
      ]));
}

class PadelReadyScreen extends StatelessWidget {
  const PadelReadyScreen({super.key});
  @override
  Widget build(BuildContext context) => _PadelShell(
      title: 'Padel match ready',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        const AppCard(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Best of 3 sets',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          SizedBox(height: 8),
          Text('Pair A serves first · Doubles'),
          SizedBox(height: 16),
          AppBadge(label: 'READY', variant: AppBadgeVariant.success)
        ])),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
            label: 'Start match',
            onPressed: () => context.push('/padel/match/live'))
      ]));
}

class PadelLiveScreen extends StatefulWidget {
  const PadelLiveScreen({super.key});
  @override
  State<PadelLiveScreen> createState() => _PadelLiveScreenState();
}

class _PadelLiveScreenState extends State<PadelLiveScreen> {
  PadelMatchState match =
      const PadelMatchState(teamA: 'Pair A', teamB: 'Pair B');
  @override
  Widget build(BuildContext context) => _PadelShell(
      title: 'Padel live',
      actions: [
        AppBadge(
            label: match.isComplete ? 'COMPLETE' : 'LIVE',
            variant: AppBadgeVariant.success)
      ],
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        AppCard(
            child: Column(children: [
          Text('Sets  ${match.setsA}  —  ${match.setsB}',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
                child: _PadelScore(
                    name: match.teamA,
                    games: match.gamesA,
                    points: match.pointsA)),
            Text('—', style: Theme.of(context).textTheme.headlineMedium),
            Expanded(
                child: _PadelScore(
                    name: match.teamB,
                    games: match.gamesB,
                    points: match.pointsB))
          ]),
          const SizedBox(height: AppSpacing.sm),
          Text('Serving: Pair ${match.servingTeam}',
              style: Theme.of(context).textTheme.bodyMedium)
        ])),
        const SizedBox(height: AppSpacing.lg),
        Row(children: [
          Expanded(
              child: PrimaryButton(
                  label: 'Pair A point',
                  onPressed: match.isComplete
                      ? null
                      : () => setState(
                          () => match = match.point(teamASelected: true)))),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
              child: SecondaryButton(
                  label: 'Pair B point',
                  onPressed: match.isComplete
                      ? null
                      : () => setState(
                          () => match = match.point(teamASelected: false))))
        ]),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Match details', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          const Text('Doubles · Best of 3 sets'),
          Text('Serve rotates after every point'),
          const SizedBox(height: AppSpacing.md),
          if (match.isComplete)
            const AppBadge(
                label: 'MATCH COMPLETE', variant: AppBadgeVariant.success)
        ])),
        const SizedBox(height: AppSpacing.lg),
        if (match.isComplete)
          PrimaryButton(
              label: 'View summary',
              onPressed: () =>
                  context.push('/padel/match/summary', extra: match))
      ]));
}

class PadelSummaryScreen extends StatelessWidget {
  const PadelSummaryScreen({required this.match, super.key});
  final PadelMatchState match;
  @override
  Widget build(BuildContext context) => _PadelShell(
      title: 'Padel summary',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        const AppBadge(label: 'COMPLETED', variant: AppBadgeVariant.success),
        const SizedBox(height: AppSpacing.md),
        AppCard(
            child: Column(children: [
          Text(match.teamA),
          Text('${match.setsA}  —  ${match.setsB}',
              style: Theme.of(context).textTheme.displayMedium),
          Text(match.teamB)
        ])),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
            label: 'Back to dashboard',
            onPressed: () => context.go('/dashboard'))
      ]));
}

class _PadelShell extends StatelessWidget {
  const _PadelShell({required this.title, required this.body, this.actions});
  final String title;
  final Widget body;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) => AppScaffold(
      appBar: SportiqAppBar(title: title, actions: actions), body: body);
}

class _PairCard extends StatelessWidget {
  const _PairCard({required this.label, required this.players});
  final String label;
  final String players;
  @override
  Widget build(BuildContext context) => AppCard(
      child: ListTile(
          leading: const Icon(Icons.groups_2_outlined,
              color: AppColors.primaryFixedDim),
          title: Text(label),
          subtitle: Text(players),
          trailing: const Icon(Icons.chevron_right)));
}

class _PadelScore extends StatelessWidget {
  const _PadelScore(
      {required this.name, required this.games, required this.points});
  final String name;
  final int games;
  final int points;
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(name),
        Text('$games', style: Theme.of(context).textTheme.displayMedium),
        Text('Points $points')
      ]);
}
