// ignore_for_file: prefer_const_constructors, prefer_const_declarations, prefer_const_literals_to_create_immutables, require_trailing_commas

import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';

class PlayerAnalyticsScreen extends StatelessWidget {
  const PlayerAnalyticsScreen({required this.playerId, super.key});
  final String playerId;
  @override
  Widget build(BuildContext context) => AppScaffold(
      appBar: SportiqAppBar(title: 'Performance'),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        AppCard(
            child: Row(children: [
          const AppAvatar(initials: 'MS', size: 56),
          const SizedBox(width: AppSpacing.md),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(playerId == 'demo' ? 'Maya Singh' : 'Player performance',
                    style: Theme.of(context).textTheme.titleLarge),
                const Text('Cricket · All-rounder')
              ]))
        ])),
        const SizedBox(height: AppSpacing.lg),
        Row(children: [
          Expanded(child: _Stat(label: 'Matches', value: '18')),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: _Stat(label: 'Win rate', value: '67%')),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: _Stat(label: 'Form', value: 'A'))
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Recent form', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
            child: Column(children: const [
          _FormRow(
              label: 'Summer League · Northside CC',
              value: '42 runs · 2 wickets'),
          _FormRow(
              label: 'City Cup · Northside CC', value: '28 runs · 1 wicket'),
          _FormRow(
              label: 'Friendly · Riverside CC', value: '51 runs · 3 wickets')
        ])),
        const SizedBox(height: AppSpacing.lg),
        Text('Sport-specific metrics',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        const AppCard(
            child: Column(children: [
          ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Batting average'),
              trailing: Text('34.6')),
          ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Strike rate'),
              trailing: Text('128.4')),
          ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Contribution'),
              trailing: Text('High',
                  style: TextStyle(color: AppColors.primaryFixedDim)))
        ]))
      ]));
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => AppCard(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        Text(label, style: Theme.of(context).textTheme.bodyMedium)
      ]));
}

class _FormRow extends StatelessWidget {
  const _FormRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(children: [
        Expanded(child: Text(label)),
        Text(value, style: Theme.of(context).textTheme.labelLarge)
      ]));
}
