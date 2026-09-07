// ignore_for_file: require_trailing_commas, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/football_match_state.dart';
import '../providers/football_setup_provider.dart';

class FootballMatchEntryScreen extends ConsumerStatefulWidget {
  const FootballMatchEntryScreen({super.key});
  @override
  ConsumerState<FootballMatchEntryScreen> createState() =>
      _FootballMatchEntryScreenState();
}

class _FootballMatchEntryScreenState
    extends ConsumerState<FootballMatchEntryScreen> {
  Future<void> _createTeam() async {
    final TextEditingController controller = TextEditingController();
    final String? name = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Create New Team'),
        content: AppTextField(controller: controller, label: 'Team name'),
        actions: <Widget>[
          TextButton(onPressed: context.pop, child: const Text('Cancel')),
          TextButton(
            onPressed: () => context.pop(controller.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (!mounted || name == null || name.isEmpty) return;
    ref.read(footballSetupProvider.notifier).addTeam(FootballTeam(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: name,
        ));
  }

  Future<void> _addPlayer(FootballTeam team) async {
    final TextEditingController controller = TextEditingController();
    final String? name = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Add Player to ${team.name}'),
        content: AppTextField(controller: controller, label: 'Player name'),
        actions: <Widget>[
          TextButton(onPressed: context.pop, child: const Text('Cancel')),
          TextButton(
            onPressed: () => context.pop(controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (!mounted || name == null || name.isEmpty) return;
    ref.read(footballSetupProvider.notifier).addPlayerToTeam(
          team.id,
          FootballPlayer(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            name: name,
            position: team.players.isEmpty ? 'GK' : 'CM',
            isGoalkeeper: team.players.isEmpty,
          ),
        );
  }

  void _continue(FootballSetupState setup) {
    final FootballTeam? home = setup.homeTeam;
    final FootballTeam? away = setup.awayTeam;
    if (home == null || away == null || home.id == away.id) {
      _error('Select different home and away teams.');
      return;
    }
    if (home.players.isEmpty || away.players.isEmpty) {
      _error('Add players to both teams before continuing.');
      return;
    }
    context.push('/football/match/lineup');
  }

  void _error(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final FootballSetupState setup = ref.watch(footballSetupProvider);
    return _FootballShell(
      title: 'Football match',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: <Widget>[
          Text('Choose or create teams',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(setup.teams.isEmpty
              ? 'No football teams yet. Create your first team.'
              : 'Select home and away teams, then add their squads.'),
          const SizedBox(height: AppSpacing.lg),
          if (setup.teams.isNotEmpty) ...<Widget>[
            DropdownButtonFormField<String>(
              initialValue: setup.homeTeamId,
              decoration: const InputDecoration(labelText: 'Home team'),
              items: setup.teams
                  .map((FootballTeam team) => DropdownMenuItem<String>(
                      value: team.id, child: Text(team.name)))
                  .toList(),
              onChanged: (String? value) =>
                  ref.read(footballSetupProvider.notifier).setHomeTeam(value),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: setup.awayTeamId,
              decoration: const InputDecoration(labelText: 'Away team'),
              items: setup.teams
                  .map((FootballTeam team) => DropdownMenuItem<String>(
                      value: team.id, child: Text(team.name)))
                  .toList(),
              onChanged: (String? value) =>
                  ref.read(footballSetupProvider.notifier).setAwayTeam(value),
            ),
            const SizedBox(height: AppSpacing.lg),
            ...setup.teams.map((FootballTeam team) => AppCard(
                  child: ListTile(
                    title: Text(team.name),
                    subtitle: Text('${team.players.length} players'),
                    trailing: IconButton(
                      tooltip: 'Add player',
                      icon: const Icon(Icons.person_add_alt_1),
                      onPressed: () => _addPlayer(team),
                    ),
                  ),
                )),
          ],
          PrimaryButton(
              label: 'Create New Team',
              icon: Icons.add,
              onPressed: _createTeam),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
              label: 'Continue to lineup', onPressed: () => _continue(setup)),
        ],
      ),
    );
  }
}

class FootballLineupScreen extends ConsumerWidget {
  const FootballLineupScreen({super.key, this.match});
  final FootballMatchState? match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FootballSetupState setup = ref.watch(footballSetupProvider);
    final FootballTeam? home = setup.homeTeam;
    final FootballTeam? away = setup.awayTeam;
    if (home == null || away == null) {
      return const _FootballShell(
          title: 'Starting lineup',
          body: Center(child: Text('Create both teams first.')));
    }
    final FootballMatchState configured = (match ??
            FootballMatchState(
                homeTeam: home,
                awayTeam: away,
                homeLineup: setup.homeLineup,
                awayLineup: setup.awayLineup,
                settings: setup.settings))
        .copyWith(
      homeLineup: setup.homeLineup.starters.isEmpty
          ? FootballLineup(
              starters: home.players.map((FootballPlayer p) => p.id).toList())
          : setup.homeLineup,
      awayLineup: setup.awayLineup.starters.isEmpty
          ? FootballLineup(
              starters: away.players.map((FootballPlayer p) => p.id).toList())
          : setup.awayLineup,
    );
    return _FootballShell(
      title: 'Starting lineup',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: <Widget>[
          _LineupCard(team: home, lineup: configured.homeLineup),
          const SizedBox(height: AppSpacing.md),
          _LineupCard(team: away, lineup: configured.awayLineup),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
              label: 'Match settings',
              onPressed: () => context.push('/football/match/settings')),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Start match',
            onPressed: () {
              final String? error =
                  configured.validateLineup(home, configured.homeLineup);
              final String? awayError =
                  configured.validateLineup(away, configured.awayLineup);
              if (error != null || awayError != null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error ?? awayError!)));
                return;
              }
              ref.read(footballSetupProvider.notifier).setLineups(
                    home: configured.homeLineup,
                    away: configured.awayLineup,
                  );
              context.push('/football/match/live', extra: configured);
            },
          ),
        ],
      ),
    );
  }
}

class FootballSettingsScreen extends ConsumerStatefulWidget {
  const FootballSettingsScreen({super.key});
  @override
  ConsumerState<FootballSettingsScreen> createState() =>
      _FootballSettingsScreenState();
}

class _FootballSettingsScreenState
    extends ConsumerState<FootballSettingsScreen> {
  late FootballMatchSettings settings;
  @override
  void initState() {
    super.initState();
    settings = ref.read(footballSetupProvider).settings;
  }

  void _save() {
    final String? error = settings.validate();
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    ref.read(footballSetupProvider.notifier).setSettings(settings);
    context.pop();
  }

  @override
  Widget build(BuildContext context) => _FootballShell(
        title: 'Football match settings',
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            SegmentedButton<FootballMatchFormat>(
              segments: const <ButtonSegment<FootballMatchFormat>>[
                ButtonSegment(
                    value: FootballMatchFormat.standard,
                    label: Text('Standard')),
                ButtonSegment(
                    value: FootballMatchFormat.friendly,
                    label: Text('Friendly')),
                ButtonSegment(
                    value: FootballMatchFormat.custom, label: Text('Custom')),
              ],
              selected: <FootballMatchFormat>{settings.format},
              onSelectionChanged: (Set<FootballMatchFormat> value) => setState(
                  () => settings = settings.copyWith(format: value.first)),
            ),
            const SizedBox(height: AppSpacing.md),
            _numberField(
                'First-half duration',
                settings.halfMinutes,
                (int value) =>
                    settings = settings.copyWith(halfMinutes: value)),
            _numberField(
                'Second-half duration',
                settings.effectiveSecondHalfMinutes,
                (int value) =>
                    settings = settings.copyWith(secondHalfMinutes: value)),
            _numberField(
                'Halftime duration',
                settings.halftimeMinutes,
                (int value) =>
                    settings = settings.copyWith(halftimeMinutes: value)),
            SwitchListTile(
                title: const Text('Stoppage time'),
                value: settings.stoppageTime,
                onChanged: (bool value) => setState(
                    () => settings = settings.copyWith(stoppageTime: value))),
            SwitchListTile(
                title: const Text('Extra time'),
                value: settings.extraTime,
                onChanged: (bool value) => setState(
                    () => settings = settings.copyWith(extraTime: value))),
            SwitchListTile(
                title: const Text('Penalty shootout'),
                value: settings.penalties,
                onChanged: (bool value) => setState(
                    () => settings = settings.copyWith(penalties: value))),
            SwitchListTile(
                title: const Text('Unlimited substitutions'),
                value: settings.unlimitedSubstitutions,
                onChanged: (bool value) => setState(() => settings =
                    settings.copyWith(unlimitedSubstitutions: value))),
            _numberField(
                'Substitution limit',
                settings.maxSubstitutes,
                (int value) =>
                    settings = settings.copyWith(maxSubstitutes: value)),
            AppTextField(
              label: 'Match / competition name',
              controller: TextEditingController(text: settings.matchName),
              onChanged: (String value) =>
                  settings = settings.copyWith(matchName: value),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Venue',
              controller: TextEditingController(text: settings.venue),
              onChanged: (String value) =>
                  settings = settings.copyWith(venue: value),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(label: 'Save settings', onPressed: _save),
          ],
        ),
      );

  Widget _numberField(String label, int value, ValueChanged<int> onChanged) =>
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: TextFormField(
          initialValue: '$value',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: label),
          onChanged: (String text) {
            final int? parsed = int.tryParse(text);
            if (parsed != null) setState(() => onChanged(parsed));
          },
        ),
      );
}

class _LineupCard extends StatelessWidget {
  const _LineupCard({required this.team, required this.lineup});
  final FootballTeam team;
  final FootballLineup lineup;
  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(team.name, style: Theme.of(context).textTheme.titleMedium),
              Text(
                  '${lineup.starters.length} starters · ${lineup.substitutes.length} substitutes'),
              ...team.players
                  .where((FootballPlayer player) =>
                      lineup.starters.contains(player.id))
                  .map((FootballPlayer player) =>
                      Text('• ${player.name} (${player.position})')),
            ]),
      );
}

class FootballLiveScreen extends StatefulWidget {
  const FootballLiveScreen({required this.initialMatch, super.key});
  final FootballMatchState initialMatch;
  @override
  State<FootballLiveScreen> createState() => _FootballLiveScreenState();
}

class _FootballLiveScreenState extends State<FootballLiveScreen> {
  late FootballMatchState match = widget.initialMatch;
  final List<FootballMatchState> history = <FootballMatchState>[];

  void _change(FootballMatchState next) {
    if (identical(next, match)) return;
    setState(() {
      history.add(match);
      match = next;
    });
  }

  Future<void> _eventMenu() async {
    final String? action = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Wrap(children: <Widget>[
          for (final String item in <String>[
            'Goal',
            'Own Goal',
            'Penalty Goal',
            'Penalty Miss',
            'Yellow Card',
            'Red Card',
            'Substitution',
            'Undo',
            'End Half',
            'End Match',
          ])
            ListTile(
                title: Text(item),
                leading: const Icon(Icons.sports_soccer),
                onTap: () => context.pop(item)),
        ]),
      ),
    );
    if (!mounted || action == null) return;
    if (action == 'Undo') {
      if (history.isNotEmpty) setState(() => match = history.removeLast());
      return;
    }
    if (action == 'Goal' ||
        action == 'Own Goal' ||
        action == 'Penalty Goal' ||
        action == 'Penalty Miss') {
      _goalDialog(action);
    } else if (action == 'Yellow Card' || action == 'Red Card') {
      _cardDialog(action == 'Yellow Card');
    } else if (action == 'Substitution') {
      _substitutionDialog();
    } else if (action == 'End Half') {
      _change(match.phase == FootballMatchPhase.halftime
          ? match.advancePhase()
          : match.tick());
    } else {
      _change(match.finish());
    }
  }

  Future<void> _goalDialog(String action) async {
    final bool? home = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(action),
        content: const Text('Select the team'),
        actions: <Widget>[
          TextButton(
              onPressed: () => context.pop(true),
              child: Text(match.homeTeam.name)),
          TextButton(
              onPressed: () => context.pop(false),
              child: Text(match.awayTeam.name)),
        ],
      ),
    );
    if (!mounted || home == null) return;
    final FootballEventType type = action == 'Own Goal'
        ? FootballEventType.ownGoal
        : action == 'Penalty Goal'
            ? FootballEventType.penaltyGoal
            : action == 'Penalty Miss'
                ? FootballEventType.penaltyMissed
                : FootballEventType.goal;
    _change(match.record(FootballMatchEvent(
        type: type,
        minute: match.minute,
        teamId: home ? match.homeTeam.id : match.awayTeam.id)));
  }

  Future<void> _cardDialog(bool yellow) async {
    final bool? home = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: yellow ? const Text('Yellow Card') : const Text('Red Card'),
        content: const Text('Select team'),
        actions: <Widget>[
          TextButton(
              onPressed: () => context.pop(true),
              child: Text(match.homeTeam.name)),
          TextButton(
              onPressed: () => context.pop(false),
              child: Text(match.awayTeam.name)),
        ],
      ),
    );
    if (!mounted || home == null) return;
    final FootballTeam team = home ? match.homeTeam : match.awayTeam;
    final String? player = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Select player'),
        children: team.players
            .map((FootballPlayer player) => SimpleDialogOption(
                onPressed: () => context.pop(player.id),
                child: Text(player.name)))
            .toList(),
      ),
    );
    if (player != null) _change(match.recordCard(player, home, yellow));
  }

  Future<void> _substitutionDialog() async {
    final bool? home = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Substitution'),
              content: const Text('Select team'),
              actions: <Widget>[
                TextButton(
                    onPressed: () => context.pop(true),
                    child: Text(match.homeTeam.name)),
                TextButton(
                    onPressed: () => context.pop(false),
                    child: Text(match.awayTeam.name)),
              ],
            ));
    if (!mounted || home == null) return;
    final FootballLineup lineup = home ? match.homeLineup : match.awayLineup;
    final String? out = await _pick('Player Out', lineup.starters, home);
    final String? inId = await _pick('Player In', lineup.substitutes, home);
    if (out != null && inId != null) _change(match.substitute(out, inId, home));
  }

  Future<String?> _pick(String title, List<String> ids, bool home) =>
      showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          final FootballTeam team = home ? match.homeTeam : match.awayTeam;
          return SimpleDialog(
            title: Text(title),
            children: ids
                .map((String id) => team.players
                    .where((FootballPlayer player) => player.id == id)
                    .map((FootballPlayer player) => SimpleDialogOption(
                        onPressed: () => context.pop(id),
                        child: Text(player.name)))
                    .first)
                .toList(),
          );
        },
      );

  @override
  Widget build(BuildContext context) => _FootballShell(
        title: 'Football live',
        actions: <Widget>[
          AppBadge(
              label: match.isComplete
                  ? 'FULL TIME'
                  : match.phase.name.toUpperCase(),
              variant: AppBadgeVariant.success),
        ],
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            AppCard(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                  _Score(name: match.homeTeam.name, score: match.homeGoals),
                  Text('—', style: Theme.of(context).textTheme.headlineMedium),
                  _Score(name: match.awayTeam.name, score: match.awayGoals),
                ])),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
                label: 'Add Event', icon: Icons.add, onPressed: _eventMenu),
            const SizedBox(height: AppSpacing.md),
            Text('${match.minute}\' · ${match.phase.name}'),
            const SizedBox(height: AppSpacing.md),
            ...match.events.reversed.map((FootballMatchEvent event) => ListTile(
                title: Text(event.type.name),
                subtitle: Text('${event.minute}\''))),
            if (match.isInPenaltyShootout()) ...<Widget>[
              Text(
                  'Shootout ${match.shootoutGoalsHome} — ${match.shootoutGoalsAway}'),
              PrimaryButton(
                  label: 'Home kick: goal',
                  onPressed: () =>
                      _change(match.recordPenaltyKick(true, true))),
              SecondaryButton(
                  label: 'Away kick: miss',
                  onPressed: () =>
                      _change(match.recordPenaltyKick(false, false))),
            ],
            SecondaryButton(
                label: 'Undo',
                onPressed: history.isEmpty
                    ? null
                    : () => setState(() => match = history.removeLast())),
            if (match.isComplete)
              PrimaryButton(
                  label: 'View summary',
                  onPressed: () =>
                      context.push('/football/match/summary', extra: match)),
          ],
        ),
      );
}

class FootballSummaryScreen extends StatelessWidget {
  const FootballSummaryScreen({required this.match, super.key});
  final FootballMatchState match;
  @override
  Widget build(BuildContext context) => _FootballShell(
        title: 'Football summary',
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            const AppBadge(
                label: 'COMPLETED', variant: AppBadgeVariant.success),
            AppCard(
                child: Column(children: <Widget>[
              Text(match.homeTeam.name),
              Text('${match.homeGoals} — ${match.awayGoals}',
                  style: Theme.of(context).textTheme.displayMedium),
              Text(match.awayTeam.name),
            ])),
            Text('${match.events.length} recorded events'),
            if (match.shootoutKicksTaken > 0)
              Text(
                  'Penalty shootout: ${match.shootoutGoalsHome} — ${match.shootoutGoalsAway}'),
            PrimaryButton(
                label: 'Back to dashboard',
                onPressed: () => context.go('/dashboard')),
          ],
        ),
      );
}

class _FootballShell extends StatelessWidget {
  const _FootballShell({required this.title, required this.body, this.actions});
  final String title;
  final Widget body;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) => AppScaffold(
      appBar: SportiqAppBar(title: title, actions: actions), body: body);
}

class _Score extends StatelessWidget {
  const _Score({required this.name, required this.score});
  final String name;
  final int score;
  @override
  Widget build(BuildContext context) => Column(children: <Widget>[
        Text(name, textAlign: TextAlign.center),
        Text('$score', style: Theme.of(context).textTheme.displayLarge),
      ]);
}
