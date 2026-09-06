// ignore_for_file: prefer_const_constructors, prefer_const_declarations, prefer_const_literals_to_create_immutables, require_trailing_commas

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';

class LiveSpectatorScreen extends StatelessWidget {
  const LiveSpectatorScreen({required this.matchId, super.key});
  final String matchId;
  @override
  Widget build(BuildContext context) => AppScaffold(
      appBar: SportiqAppBar(title: 'Live match', actions: [
        const AppBadge(label: 'LIVE', variant: AppBadgeVariant.success),
        const SizedBox(width: AppSpacing.sm)
      ]),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        Text('Northside CC  vs  Riverside CC',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
            'Cricket · ${matchId == 'demo' ? 'Community ground' : 'Live venue'}',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
            child: Column(children: [
          const Text('Northside CC',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.xs),
          Text('86 / 3', style: Theme.of(context).textTheme.displayMedium),
          const Text('11.2 overs · RR 7.58'),
          const Divider(),
          const Text('Riverside CC  yet to bat')
        ])),
        const SizedBox(height: AppSpacing.lg),
        Text('Recent events', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        const AppCard(
            child: Column(children: [
          _EventRow(label: '11.2', event: '2 runs · Maya Singh'),
          _EventRow(label: '11.1', event: 'FOUR · Maya Singh'),
          _EventRow(label: '11.0', event: 'Dot ball · Jordan Reed')
        ])),
        const SizedBox(height: AppSpacing.lg),
        Row(children: [
          Expanded(
              child: SecondaryButton(
                  label: 'Events',
                  onPressed: () => context.push('/match/$matchId/events'))),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
              child: PrimaryButton(
                  label: 'Scorecard',
                  onPressed: () => context.push('/match/$matchId/scorecard')))
        ])
      ]));
}

class MatchEventsScreen extends StatelessWidget {
  const MatchEventsScreen({required this.matchId, super.key});
  final String matchId;
  @override
  Widget build(BuildContext context) => AppScaffold(
      appBar: const SportiqAppBar(title: 'Match events'),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        Text('Live timeline', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        const _EventRow(
            label: '11.2',
            event: '2 runs · Maya Singh',
            detail: 'Northside CC 86/3'),
        const _EventRow(
            label: '11.1',
            event: 'FOUR · Maya Singh',
            detail: 'Northside CC 84/3'),
        const _EventRow(
            label: '11.0',
            event: 'Dot ball · Jordan Reed',
            detail: 'Northside CC 80/3'),
        const _EventRow(
            label: '10.6',
            event: 'Wicket · Alex Morgan',
            detail: 'Northside CC 80/3'),
        const SizedBox(height: AppSpacing.lg),
        Text('Match: $matchId', style: Theme.of(context).textTheme.bodyMedium)
      ]));
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.label, required this.event, this.detail});
  final String label;
  final String event;
  final String? detail;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: 48,
            child: Text(label, style: Theme.of(context).textTheme.labelMedium)),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(event, style: Theme.of(context).textTheme.labelLarge),
          if (detail != null)
            Text(detail!, style: Theme.of(context).textTheme.bodyMedium)
        ]))
      ]));
}
