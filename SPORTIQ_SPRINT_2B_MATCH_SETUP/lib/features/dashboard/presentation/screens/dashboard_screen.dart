// ignore_for_file: prefer_const_constructors, prefer_const_declarations, prefer_const_literals_to_create_immutables, require_trailing_commas

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';

class SportiqShell extends StatelessWidget {
  const SportiqShell({
    required this.title,
    required this.body,
    this.selectedIndex = 0,
    this.actions,
    super.key,
  });

  final String title;
  final Widget body;
  final int selectedIndex;
  final List<Widget>? actions;

  static const _routes = <String>[
    '/dashboard',
    '/search',
    '/notifications',
    '/profile'
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: SportiqAppBar(title: title, actions: actions),
      body: body,
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => context.go(_routes[index]),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
              icon: Icon(Icons.notifications_none),
              selectedIcon: Icon(Icons.notifications),
              label: 'Alerts'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SportiqShell(
      title: 'SPORTIQ',
      actions: [
        IconButton(
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_none)),
        IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined)),
      ],
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Good evening, captain',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text('Your sporting world, in one place.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          _SportSwitcher(
              onSelected: (sport) => ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$sport selected')))),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                  child: _QuickAction(
                      icon: Icons.add_circle_outline,
                      label: 'Create match',
                      onTap: () => context.push('/match/create'))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                  child: _QuickAction(
                      icon: Icons.groups_outlined,
                      label: 'My teams',
                      onTap: () => context.push('/teams'))),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _SectionHeader(
              title: 'Live now',
              action: 'View all',
              onTap: () => context.push('/match/demo/live')),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            onTap: () => context.push('/match/demo/live'),
            child: Row(
              children: [
                const AppBadge(label: 'LIVE', variant: AppBadgeVariant.success),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                    child: Text(
                        'Northside CC  86/3  ·  11.2 overs\nvs Riverside CC')),
                Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _SectionHeader(
              title: 'Upcoming',
              action: 'See schedule',
              onTap: () => context.push('/tournaments')),
          const SizedBox(height: AppSpacing.sm),
          const _MatchPreview(
              teamA: 'Falcons FC',
              teamB: 'City United',
              time: 'Tomorrow · 18:30',
              sport: 'Football'),
          const SizedBox(height: AppSpacing.sm),
          const _MatchPreview(
              teamA: 'Court One',
              teamB: 'The Baseline Pair',
              time: 'Sat · 10:00',
              sport: 'Padel'),
          const SizedBox(height: AppSpacing.xl),
          _SectionHeader(
              title: 'Your spaces',
              action: 'Open teams',
              onTap: () => context.push('/teams')),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Expanded(
                child: _Metric(
                  label: 'Teams',
                  value: '04',
                  icon: Icons.groups_outlined,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: _Metric(
                  label: 'Matches',
                  value: '18',
                  icon: Icons.sports_score_outlined,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: _Metric(
                  label: 'Win rate',
                  value: '67%',
                  icon: Icons.trending_up,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final normalized = query.trim().toLowerCase();
    final results = const [
      ('Northside CC', 'Team · Cricket', Icons.groups_outlined),
      ('Falcons FC', 'Team · Football', Icons.sports_soccer),
      ('Maya Singh', 'Player · Cricket', Icons.person_outline),
      (
        'Summer League',
        'Tournament · Multi-sport',
        Icons.emoji_events_outlined
      ),
    ]
        .where((item) =>
            normalized.isEmpty || item.$1.toLowerCase().contains(normalized))
        .toList();
    return SportiqShell(
      title: 'Search',
      selectedIndex: 1,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          SearchField(
              hint: 'Players, teams, matches or tournaments',
              onChanged: (value) => setState(() => query = value)),
          const SizedBox(height: AppSpacing.lg),
          if (normalized.isEmpty) ...[
            Text('Explore SPORTIQ',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            const Text(
                'Search across your sporting world. Results will be connected to live data when the repository is available.'),
          ] else if (results.isEmpty)
            const EmptyStateWidget(
                title: 'No results found',
                message: 'Try a different name or search term.',
                icon: Icons.search_off)
          else ...[
            Text('Results', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ...results.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.$1} selected'))),
                    child: ListTile(
                        leading:
                            Icon(item.$3, color: AppColors.primaryFixedDim),
                        title: Text(item.$1),
                        subtitle: Text(item.$2),
                        trailing: const Icon(Icons.chevron_right)),
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final read = <int>{};

  @override
  Widget build(BuildContext context) {
    final notifications = const [
      (
        'Match reminder',
        'Falcons FC play City United tomorrow at 18:30.',
        '1h',
        Icons.sports_soccer
      ),
      (
        'Team update',
        'You were added to the Northside CC squad.',
        '3h',
        Icons.groups_outlined
      ),
      (
        'Tournament result',
        'Summer League fixtures are now published.',
        'Yesterday',
        Icons.emoji_events_outlined
      ),
    ];
    return SportiqShell(
      title: 'Notifications',
      selectedIndex: 2,
      actions: [
        TextButton(
            onPressed: () => setState(() => read.addAll(
                List<int>.generate(notifications.length, (index) => index))),
            child: const Text('Mark all read'))
      ],
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              onTap: () => setState(() => read.add(index)),
              child: ListTile(
                leading: Icon(item.$4,
                    color: read.contains(index)
                        ? AppColors.onSurfaceVariant
                        : AppColors.primaryFixedDim),
                title: Text(item.$1,
                    style: read.contains(index)
                        ? null
                        : Theme.of(context).textTheme.titleMedium),
                subtitle: Text('${item.$2}\n${item.$3}'),
                isThreeLine: true,
                trailing: read.contains(index)
                    ? null
                    : const AppBadge(
                        label: 'NEW', variant: AppBadgeVariant.success),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SportiqShell(
      title: 'Profile',
      selectedIndex: 3,
      actions: [
        IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined))
      ],
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const AppCard(
              child: Row(children: [
            AppAvatar(initials: 'AM', size: 64),
            SizedBox(width: AppSpacing.md),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Alex Morgan',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                  SizedBox(height: 4),
                  Text('Player · Organizer')
                ]))
          ])),
          const SizedBox(height: AppSpacing.lg),
          const _SectionHeader(title: 'Preferred sports'),
          const SizedBox(height: AppSpacing.sm),
          const Wrap(spacing: AppSpacing.sm, children: [
            AppBadge(label: 'Cricket', variant: AppBadgeVariant.success),
            AppBadge(label: 'Football'),
            AppBadge(label: 'Padel')
          ]),
          const SizedBox(height: AppSpacing.xl),
          Row(children: const [
            Expanded(
                child: _Metric(
                    label: 'Matches',
                    value: '18',
                    icon: Icons.sports_score_outlined)),
            SizedBox(width: AppSpacing.sm),
            Expanded(
                child: _Metric(
                    label: 'Wins',
                    value: '12',
                    icon: Icons.emoji_events_outlined)),
            SizedBox(width: AppSpacing.sm),
            Expanded(
                child: _Metric(
                    label: 'Teams', value: '04', icon: Icons.groups_outlined))
          ]),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
              label: 'Edit profile',
              onPressed: () => context.push('/profile/edit')),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
              label: 'View performance',
              onPressed: () => context.push('/players/demo/analytics')),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController(text: 'Alex Morgan');
  final cityController = TextEditingController(text: 'Lahore');

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const SportiqAppBar(title: 'Edit profile'),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        const Center(child: AppAvatar(initials: 'AM', size: 88)),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(controller: nameController, label: 'Name'),
        const SizedBox(height: AppSpacing.md),
        AppTextField(controller: cityController, label: 'City'),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(label: 'Save changes', onPressed: () => context.pop()),
      ]),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const SportiqAppBar(title: 'Settings'),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        _SettingsGroup(title: 'Account', children: [
          _SettingsTile(
              icon: Icons.person_outline,
              title: 'Edit profile',
              onTap: () => context.push('/profile/edit')),
          _SettingsTile(
              icon: Icons.notifications_none,
              title: 'Notifications',
              onTap: () => context.push('/notifications')),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _SettingsGroup(title: 'Preferences', children: [
          const _SettingsTile(
              icon: Icons.dark_mode_outlined,
              title: 'Appearance',
              subtitle: 'Dark theme'),
          const _SettingsTile(
              icon: Icons.sports_score_outlined,
              title: 'Match preferences',
              subtitle: 'Your sport defaults'),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _SettingsGroup(title: 'Support', children: [
          const _SettingsTile(
              icon: Icons.help_outline, title: 'Help and support'),
          const _SettingsTile(
              icon: Icons.info_outline,
              title: 'About SPORTIQ',
              subtitle: 'Version 0.1.0'),
        ]),
        const SizedBox(height: AppSpacing.xl),
        SecondaryButton(
            label: 'Log out', onPressed: () => context.go('/welcome')),
      ]),
    );
  }
}

class ProfileReminderScreen extends StatelessWidget {
  const ProfileReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.person_add_alt_1,
                      size: 48, color: AppColors.primaryFixedDim),
                  const SizedBox(height: AppSpacing.md),
                  Text('Complete your SPORTIQ profile',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                      'Add your sports and role so your dashboard can be tailored to you.',
                      textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                      label: 'Complete profile',
                      onPressed: () => context.go('/profile/complete')),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryButton(
                      label: 'Maybe later',
                      onPressed: () => context.go('/dashboard'))
                ]))));
  }
}

class _SportSwitcher extends StatelessWidget {
  const _SportSwitcher({required this.onSelected});
  final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) => Wrap(
      spacing: AppSpacing.sm,
      children: ['Cricket', 'Football', 'Padel']
          .map((sport) => ActionChip(
              label: Text(sport),
              avatar: Icon(
                  sport == 'Cricket'
                      ? Icons.sports_cricket
                      : sport == 'Football'
                          ? Icons.sports_soccer
                          : Icons.sports_tennis,
                  size: 18),
              onPressed: () => onSelected(sport)))
          .toList());
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppCard(
      onTap: onTap,
      child: Column(children: [
        Icon(icon, color: AppColors.primaryFixedDim),
        const SizedBox(height: AppSpacing.sm),
        Text(label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge)
      ]));
}

class _MatchPreview extends StatelessWidget {
  const _MatchPreview(
      {required this.teamA,
      required this.teamB,
      required this.time,
      required this.sport});
  final String teamA;
  final String teamB;
  final String time;
  final String sport;
  @override
  Widget build(BuildContext context) => AppCard(
          child: Row(children: [
        const Icon(Icons.event_outlined, color: AppColors.primaryFixedDim),
        const SizedBox(width: AppSpacing.md),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$teamA  vs  $teamB',
              style: Theme.of(context).textTheme.titleMedium),
          Text('$time · $sport', style: Theme.of(context).textTheme.bodyMedium)
        ])),
        const Icon(Icons.chevron_right)
      ]));
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => AppCard(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 20, color: AppColors.primaryFixedDim),
        const SizedBox(height: AppSpacing.sm),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        Text(label, style: Theme.of(context).textTheme.bodyMedium)
      ]));
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action, this.onTap});
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
        if (action != null) TextButton(onPressed: onTap, child: Text(action!))
      ]);
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        AppCard(child: Column(children: children))
      ]);
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile(
      {required this.icon, required this.title, this.subtitle, this.onTap});
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryFixedDim),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      onTap: onTap);
}
