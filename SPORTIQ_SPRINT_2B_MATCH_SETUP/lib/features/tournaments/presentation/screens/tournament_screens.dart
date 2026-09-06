// ignore_for_file: prefer_const_constructors, prefer_const_declarations, prefer_const_literals_to_create_immutables, require_trailing_commas

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';

class TournamentListScreen extends StatelessWidget {
  const TournamentListScreen({super.key});
  @override
  Widget build(BuildContext context) => _TournamentShell(
      title: 'Tournaments',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        PrimaryButton(
            label: 'Create tournament',
            icon: Icons.add,
            onPressed: () => context.push('/tournaments/create')),
        const SizedBox(height: AppSpacing.lg),
        _TournamentCard(
            name: 'Summer League',
            meta: 'Multi-sport · 16 teams',
            status: 'ACTIVE',
            onTap: () => context.push('/tournaments/demo')),
        const SizedBox(height: AppSpacing.sm),
        _TournamentCard(
            name: 'City Cup',
            meta: 'Football · 8 teams',
            status: 'UPCOMING',
            onTap: () => context.push('/tournaments/city-cup'))
      ]));
}

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});
  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  final nameController = TextEditingController();
  String sport = 'Cricket';
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _TournamentShell(
      title: 'Create tournament',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        AppTextField(
            controller: nameController,
            label: 'Tournament name',
            hint: 'e.g. Summer League'),
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
            label: 'Create tournament',
            onPressed:
                nameController.text.trim().isEmpty ? null : () => context.pop())
      ]));
}

class TournamentDetailsScreen extends StatelessWidget {
  const TournamentDetailsScreen({required this.tournamentId, super.key});
  final String tournamentId;
  @override
  Widget build(BuildContext context) => _TournamentShell(
      title: 'Tournament details',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        AppCard(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text(
                    tournamentId == 'demo' ? 'Summer League' : 'City Cup',
                    style: Theme.of(context).textTheme.headlineMedium)),
            const AppBadge(label: 'ACTIVE', variant: AppBadgeVariant.success)
          ]),
          const SizedBox(height: AppSpacing.sm),
          const Text(
              'A shared competition space for teams, fixtures and results.'),
          const SizedBox(height: AppSpacing.lg),
          Row(children: [
            Expanded(child: _TournamentMetric(value: '16', label: 'Teams')),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _TournamentMetric(value: '24', label: 'Fixtures')),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _TournamentMetric(value: '04', label: 'Rounds'))
          ])
        ])),
        const SizedBox(height: AppSpacing.lg),
        _TournamentLink(
            title: 'Fixtures',
            icon: Icons.event_note_outlined,
            onTap: () => context.push('/tournaments/$tournamentId/fixtures')),
        _TournamentLink(
            title: 'Standings',
            icon: Icons.table_chart_outlined,
            onTap: () => context.push('/tournaments/$tournamentId/standings')),
        _TournamentLink(
            title: 'Bracket',
            icon: Icons.account_tree_outlined,
            onTap: () => context.push('/tournaments/$tournamentId/bracket')),
        _TournamentLink(
            title: 'Player rankings',
            icon: Icons.leaderboard_outlined,
            onTap: () => context.push('/tournaments/$tournamentId/rankings'))
      ]));
}

class TournamentFixturesScreen extends StatelessWidget {
  const TournamentFixturesScreen({required this.tournamentId, super.key});
  final String tournamentId;
  @override
  Widget build(BuildContext context) => _TournamentShell(
      title: 'Fixtures',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        _FixtureCard(
            round: 'Round 3',
            date: 'Sat · 10:00',
            teams: 'Northside CC  vs  Riverside CC'),
        _FixtureCard(
            round: 'Round 3',
            date: 'Sat · 14:30',
            teams: 'Falcons FC  vs  City United'),
        _FixtureCard(
            round: 'Round 4',
            date: 'Sun · 12:00',
            teams: 'Baseline Pair  vs  Court One'),
        Text('Tournament: $tournamentId',
            style: Theme.of(context).textTheme.bodyMedium)
      ]));
}

class TournamentStandingsScreen extends StatelessWidget {
  const TournamentStandingsScreen({required this.tournamentId, super.key});
  final String tournamentId;
  @override
  Widget build(BuildContext context) {
    const rows = [
      ('Northside CC', '6', '12'),
      ('Riverside CC', '6', '10'),
      ('City United', '6', '8'),
      ('Falcons FC', '6', '6')
    ];
    return _TournamentShell(
        title: 'Standings',
        body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
          AppCard(
              child: Column(children: [
            const _StandingRow(
                position: '#', team: 'Team', played: 'P', points: 'Pts'),
            ...rows.asMap().entries.map((entry) => _StandingRow(
                position: '${entry.key + 1}',
                team: entry.value.$1,
                played: entry.value.$2,
                points: entry.value.$3))
          ])),
          const SizedBox(height: AppSpacing.md),
          Text('Tournament: $tournamentId',
              style: Theme.of(context).textTheme.bodyMedium)
        ]));
  }
}

class TournamentBracketScreen extends StatelessWidget {
  const TournamentBracketScreen({required this.tournamentId, super.key});
  final String tournamentId;
  @override
  Widget build(BuildContext context) => _TournamentShell(
      title: 'Bracket',
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        const _BracketRound(
            title: 'Semi-final 1',
            teamA: 'Northside CC',
            teamB: 'Riverside CC'),
        const SizedBox(height: AppSpacing.md),
        const _BracketRound(
            title: 'Semi-final 2', teamA: 'Falcons FC', teamB: 'City United'),
        const SizedBox(height: AppSpacing.md),
        const _BracketRound(
            title: 'Final', teamA: 'Winner SF1', teamB: 'Winner SF2'),
        Text('Tournament: $tournamentId',
            style: Theme.of(context).textTheme.bodyMedium)
      ]));
}

class TournamentRankingsScreen extends StatelessWidget {
  const TournamentRankingsScreen({required this.tournamentId, super.key});
  final String tournamentId;
  @override
  Widget build(BuildContext context) => _TournamentShell(
      title: 'Player rankings',
      body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            ('Maya Singh', 'Northside CC', '142 pts'),
            ('Jordan Reed', 'Falcons FC', '128 pts'),
            ('Taylor Khan', 'Riverside CC', '117 pts')
          ]
              .asMap()
              .entries
              .map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                      child: ListTile(
                          leading: Text('${entry.key + 1}',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          title: Text(entry.value.$1),
                          subtitle: Text(entry.value.$2),
                          trailing: Text(entry.value.$3,
                              style: Theme.of(context).textTheme.labelLarge)))))
              .toList()));
}

class _TournamentShell extends StatelessWidget {
  const _TournamentShell({required this.title, required this.body});
  final String title;
  final Widget body;
  @override
  Widget build(BuildContext context) =>
      AppScaffold(appBar: SportiqAppBar(title: title), body: body);
}

class _TournamentCard extends StatelessWidget {
  const _TournamentCard(
      {required this.name,
      required this.meta,
      required this.status,
      required this.onTap});
  final String name;
  final String meta;
  final String status;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppCard(
      onTap: onTap,
      child: Row(children: [
        const Icon(Icons.emoji_events_outlined,
            color: AppColors.primaryFixedDim),
        const SizedBox(width: AppSpacing.md),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: Theme.of(context).textTheme.titleMedium),
          Text(meta, style: Theme.of(context).textTheme.bodyMedium)
        ])),
        AppBadge(label: status),
        const SizedBox(width: AppSpacing.sm),
        const Icon(Icons.chevron_right)
      ]));
}

class _TournamentMetric extends StatelessWidget {
  const _TournamentMetric({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        Text(label, style: Theme.of(context).textTheme.bodyMedium)
      ]);
}

class _TournamentLink extends StatelessWidget {
  const _TournamentLink(
      {required this.title, required this.icon, required this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
          onTap: onTap,
          child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(icon, color: AppColors.primaryFixedDim),
              title: Text(title),
              trailing: const Icon(Icons.chevron_right))));
}

class _FixtureCard extends StatelessWidget {
  const _FixtureCard(
      {required this.round, required this.date, required this.teams});
  final String round;
  final String date;
  final String teams;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
          child: ListTile(
              leading: const Icon(Icons.event_outlined,
                  color: AppColors.primaryFixedDim),
              title: Text(teams),
              subtitle: Text('$round · $date'),
              trailing: const AppBadge(label: 'UPCOMING'))));
}

class _StandingRow extends StatelessWidget {
  const _StandingRow(
      {required this.position,
      required this.team,
      required this.played,
      required this.points});
  final String position;
  final String team;
  final String played;
  final String points;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              position,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Expanded(child: Text(team)),
          SizedBox(
            width: 42,
            child: Text(played, textAlign: TextAlign.center),
          ),
          SizedBox(
            width: 42,
            child: Text(
              points,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _BracketRound extends StatelessWidget {
  const _BracketRound(
      {required this.title, required this.teamA, required this.teamB});
  final String title;
  final String teamA;
  final String teamB;
  @override
  Widget build(BuildContext context) => AppCard(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Text(teamA),
        const Divider(),
        Text(teamB)
      ]));
}
