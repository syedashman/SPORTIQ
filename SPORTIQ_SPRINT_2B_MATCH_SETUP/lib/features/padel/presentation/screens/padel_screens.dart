// ignore_for_file: require_trailing_commas, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/padel_match_state.dart';
import '../providers/padel_setup_provider.dart';

class PadelMatchEntryScreen extends ConsumerStatefulWidget {
  const PadelMatchEntryScreen({super.key});
  @override
  ConsumerState<PadelMatchEntryScreen> createState() =>
      _PadelMatchEntryScreenState();
}

class _PadelMatchEntryScreenState extends ConsumerState<PadelMatchEntryScreen> {
  Future<void> _addPlayer() async {
    final TextEditingController controller = TextEditingController();
    final String? name = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add Player'),
        content: AppTextField(controller: controller, label: 'Player name'),
        actions: <Widget>[
          TextButton(onPressed: context.pop, child: const Text('Cancel')),
          TextButton(
              onPressed: () => context.pop(controller.text.trim()),
              child: const Text('Add')),
        ],
      ),
    );
    if (!mounted || name == null || name.isEmpty) return;
    ref.read(padelSetupProvider.notifier).addPlayer(PadelPlayer(
        id: DateTime.now().microsecondsSinceEpoch.toString(), name: name));
  }

  PadelPlayer? _find(List<PadelPlayer> players, String? id) {
    for (final PadelPlayer player in players) {
      if (player.id == id) return player;
    }
    return null;
  }

  void _continue(PadelSetupState setup) {
    final List<PadelPlayer?> selected =
        setup.matchType == PadelMatchType.singles
            ? <PadelPlayer?>[setup.teamAPlayer1, setup.teamBPlayer1]
            : <PadelPlayer?>[
                setup.teamAPlayer1,
                setup.teamAPlayer2,
                setup.teamBPlayer1,
                setup.teamBPlayer2
              ];
    if (selected.any((PadelPlayer? player) => player == null) ||
        selected.map((PadelPlayer? player) => player!.id).toSet().length !=
            selected.length) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Select different players for every position.')));
      return;
    }
    if (setup.settings.validate() case final String error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    final PadelPair pairA = PadelPair(
        id: 'A',
        name: setup.matchType == PadelMatchType.singles
            ? setup.teamAPlayer1!.name
            : 'Pair A',
        players: <PadelPlayer>[
          setup.teamAPlayer1!,
          if (setup.matchType == PadelMatchType.doubles) setup.teamAPlayer2!
        ]);
    final PadelPair pairB = PadelPair(
        id: 'B',
        name: setup.matchType == PadelMatchType.singles
            ? setup.teamBPlayer1!.name
            : 'Pair B',
        players: <PadelPlayer>[
          setup.teamBPlayer1!,
          if (setup.matchType == PadelMatchType.doubles) setup.teamBPlayer2!
        ]);
    final List<String> order = setup.matchType == PadelMatchType.singles
        ? <String>[setup.teamAPlayer1!.id, setup.teamBPlayer1!.id]
        : <String>[
            setup.teamAPlayer1!.id,
            setup.teamBPlayer1!.id,
            setup.teamAPlayer2!.id,
            setup.teamBPlayer2!.id
          ];
    ref.read(padelSetupProvider.notifier).setServiceOrder(order);
    context.push('/padel/match/ready',
        extra: PadelMatchState(
          teamA: pairA,
          teamB: pairB,
          matchType: setup.matchType,
          settings: setup.settings,
          firstServerId: setup.firstServerId,
          serviceOrder: order,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final PadelSetupState setup = ref.watch(padelSetupProvider);
    final List<PadelPlayer> players = setup.players;
    Widget field(String label, PadelPlayer? value,
            ValueChanged<PadelPlayer?> onChanged) =>
        DropdownButtonFormField<String>(
          initialValue: value?.id,
          decoration: InputDecoration(labelText: label),
          items: players
              .map((PadelPlayer player) => DropdownMenuItem<String>(
                  value: player.id, child: Text(player.name)))
              .toList(),
          onChanged: (String? id) => onChanged(_find(players, id)),
        );
    return _PadelShell(
      title: 'Padel match',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: <Widget>[
          Text('Create players or pairs',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<PadelMatchType>(
            segments: const <ButtonSegment<PadelMatchType>>[
              ButtonSegment(
                  value: PadelMatchType.singles, label: Text('Singles')),
              ButtonSegment(
                  value: PadelMatchType.doubles, label: Text('Doubles')),
            ],
            selected: <PadelMatchType>{setup.matchType},
            onSelectionChanged: (Set<PadelMatchType> value) =>
                ref.read(padelSetupProvider.notifier).setMatchType(value.first),
          ),
          const SizedBox(height: AppSpacing.md),
          field(
              'Pair A player 1',
              setup.teamAPlayer1,
              (PadelPlayer? p) =>
                  ref.read(padelSetupProvider.notifier).setTeamAPlayer1(p)),
          if (setup.matchType == PadelMatchType.doubles) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            field(
                'Pair A player 2',
                setup.teamAPlayer2,
                (PadelPlayer? p) =>
                    ref.read(padelSetupProvider.notifier).setTeamAPlayer2(p)),
          ],
          const SizedBox(height: AppSpacing.md),
          field(
              'Pair B player 1',
              setup.teamBPlayer1,
              (PadelPlayer? p) =>
                  ref.read(padelSetupProvider.notifier).setTeamBPlayer1(p)),
          if (setup.matchType == PadelMatchType.doubles) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            field(
                'Pair B player 2',
                setup.teamBPlayer2,
                (PadelPlayer? p) =>
                    ref.read(padelSetupProvider.notifier).setTeamBPlayer2(p)),
          ],
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
              label: 'Add Player',
              icon: Icons.person_add_alt_1,
              onPressed: _addPlayer),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
              label: 'Match settings',
              onPressed: () => context.push('/padel/match/settings')),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
              label: 'Continue to match ready',
              onPressed: () => _continue(setup)),
        ],
      ),
    );
  }
}

class PadelSettingsScreen extends ConsumerStatefulWidget {
  const PadelSettingsScreen({super.key});
  @override
  ConsumerState<PadelSettingsScreen> createState() => _PadelSettingsState();
}

class _PadelSettingsState extends ConsumerState<PadelSettingsScreen> {
  late PadelMatchSettings settings;
  @override
  void initState() {
    super.initState();
    settings = ref.read(padelSetupProvider).settings;
  }

  @override
  Widget build(BuildContext context) => _PadelShell(
        title: 'Padel match settings',
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            Text('Best of sets',
                style: Theme.of(context).textTheme.titleMedium),
            DropdownButtonFormField<int>(
              initialValue: settings.bestOfSets,
              items: const <DropdownMenuItem<int>>[
                DropdownMenuItem(value: 1, child: Text('1')),
                DropdownMenuItem(value: 3, child: Text('3')),
                DropdownMenuItem(value: 5, child: Text('5')),
              ],
              onChanged: (int? value) => setState(
                  () => settings = settings.copyWith(bestOfSets: value)),
            ),
            SwitchListTile(
                title: const Text('Advantage scoring'),
                value: settings.advantageScoring,
                onChanged: (bool value) => setState(() =>
                    settings = settings.copyWith(advantageScoring: value))),
            SwitchListTile(
                title: const Text('Golden point'),
                value: settings.goldenPoint,
                onChanged: (bool value) => setState(
                    () => settings = settings.copyWith(goldenPoint: value))),
            SwitchListTile(
                title: const Text('Tie-break enabled'),
                value: settings.tieBreakEnabled,
                onChanged: (bool value) => setState(() =>
                    settings = settings.copyWith(tieBreakEnabled: value))),
            TextFormField(
              initialValue: '${settings.tieBreakTarget}',
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tie-break target'),
              onChanged: (String value) {
                final int? parsed = int.tryParse(value);
                if (parsed != null) {
                  setState(() =>
                      settings = settings.copyWith(tieBreakTarget: parsed));
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
                label: 'Save settings',
                onPressed: () {
                  final String? error = settings.validate();
                  if (error != null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(error)));
                    return;
                  }
                  ref.read(padelSetupProvider.notifier).setSettings(settings);
                  context.pop();
                }),
          ],
        ),
      );
}

class PadelReadyScreen extends ConsumerWidget {
  const PadelReadyScreen({required this.match, super.key});
  final PadelMatchState match;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PadelSetupState setup = ref.watch(padelSetupProvider);
    final List<String> ids = match.serviceOrder.isEmpty
        ? match.teamA.players
            .followedBy(match.teamB.players)
            .map((PadelPlayer p) => p.id)
            .toList()
        : match.serviceOrder;
    return _PadelShell(
      title: 'Padel match ready',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: <Widget>[
          AppCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text('${match.teamA.name} vs ${match.teamB.name}',
                    style: Theme.of(context).textTheme.titleLarge),
                Text(
                    'Best of ${match.settings.bestOfSets} sets · ${match.matchType.name}'),
                const SizedBox(height: AppSpacing.md),
                const Text('First server'),
                DropdownButton<String>(
                  value: setup.firstServerId,
                  hint: const Text('Select first server'),
                  items: ids
                      .map((String id) => DropdownMenuItem<String>(
                          value: id, child: Text(_playerName(match, id))))
                      .toList(),
                  onChanged: (String? id) {
                    if (id != null)
                      ref.read(padelSetupProvider.notifier).setFirstServer(id);
                  },
                ),
                if (match.matchType == PadelMatchType.doubles)
                  const Text(
                      'Service order: Pair A player 1, Pair B player 1, Pair A player 2, Pair B player 2'),
              ])),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
              label: 'Start match',
              onPressed: setup.firstServerId == null
                  ? null
                  : () => context.push('/padel/match/live',
                      extra: match.copyWithForStart(
                          firstServerId: setup.firstServerId))),
        ],
      ),
    );
  }
}

String _playerName(PadelMatchState match, String id) => match.teamA.players
    .followedBy(match.teamB.players)
    .firstWhere((PadelPlayer p) => p.id == id)
    .name;

class PadelLiveScreen extends StatefulWidget {
  const PadelLiveScreen({required this.initialMatch, super.key});
  final PadelMatchState initialMatch;
  @override
  State<PadelLiveScreen> createState() => _PadelLiveScreenState();
}

class _PadelLiveScreenState extends State<PadelLiveScreen> {
  late PadelMatchState match = widget.initialMatch;
  final List<PadelMatchState> history = <PadelMatchState>[];
  void _point(bool teamA) => setState(() {
        history.add(match);
        match = match.point(teamASelected: teamA);
      });
  @override
  Widget build(BuildContext context) => _PadelShell(
        title: 'Padel live',
        actions: <Widget>[
          AppBadge(
              label: match.isComplete ? 'COMPLETE' : 'LIVE',
              variant: AppBadgeVariant.success),
        ],
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            AppCard(
                child: Column(children: <Widget>[
              Text('Sets ${match.setsA} — ${match.setsB}'),
              Text('Games ${match.gamesA} — ${match.gamesB}'),
              Text(match.tieBreak
                  ? 'Tie-break ${match.tieBreakPointsA} — ${match.tieBreakPointsB}'
                  : match.pointScore),
              Text('Serving: ${match.servingPlayerId ?? match.servingTeam}'),
            ])),
            const SizedBox(height: AppSpacing.lg),
            Row(children: <Widget>[
              Expanded(
                  child: PrimaryButton(
                      label: '${match.teamA.name} point',
                      onPressed: match.isComplete ? null : () => _point(true))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                  child: SecondaryButton(
                      label: '${match.teamB.name} point',
                      onPressed:
                          match.isComplete ? null : () => _point(false))),
            ]),
            SecondaryButton(
                label: 'Undo last point',
                onPressed: history.isEmpty
                    ? null
                    : () => setState(() => match = history.removeLast())),
            if (match.isComplete)
              PrimaryButton(
                  label: 'View summary',
                  onPressed: () =>
                      context.push('/padel/match/summary', extra: match)),
          ],
        ),
      );
}

class PadelSummaryScreen extends StatelessWidget {
  const PadelSummaryScreen({required this.match, super.key});
  final PadelMatchState match;
  @override
  Widget build(BuildContext context) => _PadelShell(
        title: 'Padel summary',
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            const AppBadge(
                label: 'COMPLETED', variant: AppBadgeVariant.success),
            AppCard(
                child: Column(children: <Widget>[
              Text(match.teamA.name),
              Text('${match.setsA} — ${match.setsB}',
                  style: Theme.of(context).textTheme.displayMedium),
              Text(match.teamB.name),
            ])),
            ...match.completedSets.map((String score) => Text('Set: $score')),
            PrimaryButton(
                label: 'Back to dashboard',
                onPressed: () => context.go('/dashboard')),
          ],
        ),
      );
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

extension on PadelMatchState {
  PadelMatchState copyWithForStart({String? firstServerId}) => PadelMatchState(
        teamA: teamA,
        teamB: teamB,
        matchType: matchType,
        settings: settings,
        servingTeam: servingTeam,
        firstServerId: firstServerId ?? this.firstServerId,
        serviceOrder: serviceOrder,
      );
}
