import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/match_setup_data.dart';
import '../widgets/setup_scaffold.dart';

class AddPlayersScreen extends StatefulWidget {
  const AddPlayersScreen({
    required this.teamA,
    required this.teamB,
    super.key,
  });

  final String teamA;
  final String teamB;

  @override
  State<AddPlayersScreen> createState() => _AddPlayersScreenState();
}

class _AddPlayersScreenState extends State<AddPlayersScreen> {
  late final List<String> _teamAPlayers;
  late final List<String> _teamBPlayers;

  int _selectedTeam = 0;

  @override
  void initState() {
    super.initState();

    _teamAPlayers = <String>[
      '${widget.teamA} Captain',
    ];

    _teamBPlayers = <String>[
      '${widget.teamB} Captain',
    ];
  }

  List<String> get _activePlayers {
    return _selectedTeam == 0 ? _teamAPlayers : _teamBPlayers;
  }

  String get _activeTeamName {
    return _selectedTeam == 0 ? widget.teamA : widget.teamB;
  }

  bool get _bothTeamsHaveEnoughPlayers {
    return _teamAPlayers.length >= 2 && _teamBPlayers.length >= 2;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  bool _playerAlreadyExists(String playerName) {
    final String normalizedName = playerName.trim().toLowerCase();

    return _activePlayers.any(
      (String existingPlayer) =>
          existingPlayer.trim().toLowerCase() == normalizedName,
    );
  }

  Future<void> _showAddPlayerSheet() async {
    final TextEditingController controller = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceRaised,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.glassStroke,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Add Player',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Add a player to $_activeTeamName.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 30,
                  decoration: const InputDecoration(
                    labelText: 'Player name',
                    hintText: 'Enter full name',
                    prefixIcon: Icon(
                      Icons.person_add_alt_1,
                    ),
                  ),
                  onSubmitted: (String value) {
                    _addTemporaryPlayer(
                      sheetContext,
                      controller,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: 'Add Temporary Player',
                  onPressed: () {
                    _addTemporaryPlayer(
                      sheetContext,
                      controller,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();

                    _showMessage(
                      'Invite links will be connected with the backend later.',
                    );
                  },
                  icon: const Icon(
                    Icons.link,
                  ),
                  label: const Text(
                    'Invite with Link',
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();

                    _showMessage(
                      'Existing-player search will be connected later.',
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                  label: const Text(
                    'Add Existing Player',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    controller.dispose();
  }

  void _addTemporaryPlayer(
    BuildContext sheetContext,
    TextEditingController controller,
  ) {
    final String playerName = controller.text.trim();

    if (playerName.isEmpty) {
      return;
    }

    if (_playerAlreadyExists(playerName)) {
      Navigator.of(sheetContext).pop();

      _showMessage(
        '$playerName is already added to $_activeTeamName.',
      );

      return;
    }

    setState(() {
      _activePlayers.add(playerName);
    });

    Navigator.of(sheetContext).pop();
  }

  Future<void> _showEditPlayerDialog({
    required int playerIndex,
    required String currentName,
  }) async {
    final TextEditingController controller = TextEditingController(
      text: currentName,
    );

    final String? updatedName = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Edit Player Name',
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            maxLength: 30,
            decoration: const InputDecoration(
              labelText: 'Player name',
            ),
            onSubmitted: (String value) {
              final String name = value.trim();

              if (name.isNotEmpty) {
                Navigator.of(dialogContext).pop(name);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                final String name = controller.text.trim();

                if (name.isNotEmpty) {
                  Navigator.of(dialogContext).pop(name);
                }
              },
              child: const Text(
                'Save',
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (updatedName == null || updatedName.trim().isEmpty) {
      return;
    }

    final String normalizedUpdatedName = updatedName.trim().toLowerCase();

    final bool duplicateExists = _activePlayers.asMap().entries.any(
      (MapEntry<int, String> entry) {
        return entry.key != playerIndex &&
            entry.value.trim().toLowerCase() == normalizedUpdatedName;
      },
    );

    if (duplicateExists) {
      _showMessage(
        '$updatedName is already added to $_activeTeamName.',
      );

      return;
    }

    setState(() {
      _activePlayers[playerIndex] = updatedName.trim();
    });
  }

  void _removePlayer(int playerIndex) {
    if (_activePlayers.length <= 1) {
      _showMessage(
        'Each team must keep at least one player.',
      );

      return;
    }

    setState(() {
      _activePlayers.removeAt(playerIndex);
    });
  }

  void _continueToMatchSettings() {
    if (!_bothTeamsHaveEnoughPlayers) {
      _showMessage(
        'Add at least 2 players to both teams before continuing.',
      );

      return;
    }

    final MatchSetupData matchSetupData = MatchSetupData(
      teamA: widget.teamA,
      teamB: widget.teamB,
      teamAPlayers: List<String>.unmodifiable(
        _teamAPlayers,
      ),
      teamBPlayers: List<String>.unmodifiable(
        _teamBPlayers,
      ),
    );

    context.push(
      AppRoutes.cricketSettings,
      extra: matchSetupData,
    );
  }

  Widget _buildTeamCount({
    required String teamName,
    required int playerCount,
    required bool isSelected,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primaryFixedDim : AppColors.surfaceRaised,
          borderRadius: AppRadius.smRadius,
          border: Border.all(
            color:
                isSelected ? AppColors.primaryFixedDim : AppColors.glassStroke,
          ),
        ),
        child: Column(
          children: [
            Text(
              teamName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              '$playerCount players',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        isSelected ? Colors.black87 : AppColors.primaryFixedDim,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCard({
    required int playerIndex,
    required String playerName,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: AppSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadius.smRadius,
        border: Border.all(
          color: AppColors.glassStroke,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.surfaceBright,
            child: Text(
              '${playerIndex + 1}',
              style: const TextStyle(
                color: AppColors.primaryFixedDim,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              playerName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          IconButton(
            tooltip: 'Edit player',
            onPressed: () {
              _showEditPlayerDialog(
                playerIndex: playerIndex,
                currentName: playerName,
              );
            },
            icon: const Icon(
              Icons.edit_outlined,
            ),
          ),
          IconButton(
            tooltip: 'Remove player',
            onPressed: () {
              _removePlayer(playerIndex);
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SetupScaffold(
      step: 'Step 2 of 5',
      title: 'Add Players',
      subtitle:
          'Build both team lineups. These players will be used for batting and bowling selection.',
      bottom: PrimaryButton(
        label: 'Match Settings',
        onPressed: _continueToMatchSettings,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<int>(
            segments: <ButtonSegment<int>>[
              ButtonSegment<int>(
                value: 0,
                label: Text(
                  widget.teamA,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ButtonSegment<int>(
                value: 1,
                label: Text(
                  widget.teamB,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            selected: <int>{
              _selectedTeam,
            },
            onSelectionChanged: (Set<int> selection) {
              setState(() {
                _selectedTeam = selection.first;
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildTeamCount(
                teamName: widget.teamA,
                playerCount: _teamAPlayers.length,
                isSelected: _selectedTeam == 0,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildTeamCount(
                teamName: widget.teamB,
                playerCount: _teamBPlayers.length,
                isSelected: _selectedTeam == 1,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$_activeTeamName Players',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Text(
                '${_activePlayers.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primaryFixedDim,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ..._activePlayers.asMap().entries.map(
                (MapEntry<int, String> entry) => _buildPlayerCard(
                  playerIndex: entry.key,
                  playerName: entry.value,
                ),
              ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            key: const Key(
              'addPlayerButton',
            ),
            onPressed: _showAddPlayerSheet,
            icon: const Icon(
              Icons.add,
            ),
            label: Text(
              'Add Player to $_activeTeamName',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(
              AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: AppRadius.smRadius,
              border: Border.all(
                color: AppColors.glassStroke,
              ),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primaryFixedDim,
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Add at least two players to each team. After the toss, batters will be selected from the batting team and the bowler from the bowling team.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
