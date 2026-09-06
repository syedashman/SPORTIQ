import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../widgets/setup_scaffold.dart';

class CreateTeamsScreen extends StatefulWidget {
  const CreateTeamsScreen({super.key});

  @override
  State<CreateTeamsScreen> createState() => _CreateTeamsScreenState();
}

class _CreateTeamsScreenState extends State<CreateTeamsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamA = TextEditingController(text: 'Team A');
  final _teamB = TextEditingController(text: 'Team B');

  @override
  void dispose() {
    _teamA.dispose();
    _teamB.dispose();
    super.dispose();
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.push(
      AppRoutes.addPlayers,
      extra: {'teamA': _teamA.text.trim(), 'teamB': _teamB.text.trim()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return SetupScaffold(
      step: 'Step 1 of 5',
      title: 'Create Teams',
      subtitle: 'Name both sides. You can add players on the next screen.',
      bottom: PrimaryButton(label: 'Add Players', onPressed: _continue),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _TeamField(label: 'Home Team', controller: _teamA),
            const SizedBox(height: AppSpacing.lg),
            _TeamField(label: 'Away Team', controller: _teamB),
          ],
        ),
      ),
    );
  }
}

class _TeamField extends StatelessWidget {
  const _TeamField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: AppColors.glassStroke),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.groups_2_outlined),
        ),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Enter a team name' : null,
      ),
    );
  }
}
