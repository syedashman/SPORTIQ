// ignore_for_file: prefer_const_constructors, prefer_const_declarations, prefer_const_literals_to_create_immutables, require_trailing_commas

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const teams = [
      ('Northside CC', 'Cricket', '12 players'),
      ('Falcons FC', 'Football', '18 players'),
      ('Baseline Pair', 'Padel', '2 players')
    ];
    return _ResourceShell(
        title: 'Teams',
        body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
          PrimaryButton(
              label: 'Create team',
              icon: Icons.add,
              onPressed: () => context.push('/match/demo/team-setup')),
          const SizedBox(height: AppSpacing.lg),
          ...teams.map((team) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard(
                  onTap: () => context.push('/teams/demo'),
                  child: ListTile(
                      leading: AppAvatar(
                          initials: team.$1.substring(0, 2).toUpperCase()),
                      title: Text(team.$1),
                      subtitle: Text('${team.$2} · ${team.$3}'),
                      trailing: const Icon(Icons.chevron_right)))))
        ]));
  }
}

class TeamDetailsScreen extends StatelessWidget {
  const TeamDetailsScreen({required this.teamId, super.key});
  final String teamId;
  @override
  Widget build(BuildContext context) => _ResourceShell(
      title: 'Team details',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        AppCard(
            child: Row(children: [
          const AppAvatar(initials: 'NC', size: 64),
          const SizedBox(width: AppSpacing.md),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Northside CC',
                    style: Theme.of(context).textTheme.headlineMedium),
                const Text('Cricket · Community team'),
                const SizedBox(height: AppSpacing.xs),
                AppBadge(label: teamId == 'demo' ? 'ACTIVE' : 'TEAM')
              ]))
        ])),
        const SizedBox(height: AppSpacing.lg),
        Row(children: [
          Expanded(child: _TeamMetric(label: 'Matches', value: '18')),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: _TeamMetric(label: 'Wins', value: '12')),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: _TeamMetric(label: 'Members', value: '12'))
        ]),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
            label: 'View players',
            onPressed: () => context.push('/teams/$teamId/players')),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
            label: 'Invite players',
            onPressed: () => context.push('/teams/$teamId/invite')),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
            label: 'Create match',
            onPressed: () => context.push('/match/create'))
      ]));
}

class TeamPlayersScreen extends StatelessWidget {
  const TeamPlayersScreen({required this.teamId, super.key});
  final String teamId;
  @override
  Widget build(BuildContext context) {
    const players = [
      ('AM', 'Alex Morgan', 'Captain'),
      ('MS', 'Maya Singh', 'All-rounder'),
      ('JR', 'Jordan Reed', 'Player'),
      ('TK', 'Taylor Khan', 'Player')
    ];
    return _ResourceShell(
        title: 'Team players',
        body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
          Text('Northside CC roster',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          ...players.map((player) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard(
                  child: ListTile(
                      leading: AppAvatar(initials: player.$1),
                      title: Text(player.$2),
                      subtitle: Text(player.$3),
                      trailing: const Icon(Icons.chevron_right))))),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
              label: 'Invite to $teamId',
              onPressed: () => context.push('/teams/$teamId/invite'))
        ]));
  }
}

class TeamInviteScreen extends StatefulWidget {
  const TeamInviteScreen({required this.teamId, super.key});
  final String teamId;
  @override
  State<TeamInviteScreen> createState() => _TeamInviteScreenState();
}

class _TeamInviteScreenState extends State<TeamInviteScreen> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _ResourceShell(
      title: 'Invite players',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        Text('Invite to ${widget.teamId}',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
            controller: controller,
            label: 'Email or username',
            hint: 'player@sportiq.app'),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
            label: 'Send invite',
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invite ready to send when connected')));
            })
      ]));
}

class TeamSetupScreen extends StatefulWidget {
  const TeamSetupScreen({super.key});
  @override
  State<TeamSetupScreen> createState() => _TeamSetupScreenState();
}

class _TeamSetupScreenState extends State<TeamSetupScreen> {
  final nameController = TextEditingController();
  String sport = 'Cricket';
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _ResourceShell(
      title: 'Create team',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        AppTextField(
            controller: nameController,
            label: 'Team name',
            hint: 'e.g. Northside CC'),
        const SizedBox(height: AppSpacing.lg),
        Text('Sport', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
            spacing: AppSpacing.sm,
            children: ['Cricket', 'Football', 'Padel']
                .map((value) => ChoiceChip(
                    label: Text(value),
                    selected: sport == value,
                    onSelected: (_) => setState(() => sport = value)))
                .toList()),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
            label: 'Create team',
            onPressed:
                nameController.text.trim().isEmpty ? null : () => context.pop())
      ]));
}

class _ResourceShell extends StatelessWidget {
  const _ResourceShell({required this.title, required this.body});
  final String title;
  final Widget body;
  @override
  Widget build(BuildContext context) =>
      AppScaffold(appBar: SportiqAppBar(title: title), body: body);
}

class _TeamMetric extends StatelessWidget {
  const _TeamMetric({required this.label, required this.value});
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
