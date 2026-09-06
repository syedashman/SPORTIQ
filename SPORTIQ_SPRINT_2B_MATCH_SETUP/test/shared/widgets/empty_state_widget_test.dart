import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportiq/shared/theme/theme.dart';
import 'package:sportiq/shared/widgets/states/empty_state_widget.dart';

void main() {
  testWidgets('EmptyStateWidget renders title and message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: EmptyStateWidget(
            title: 'No matches yet',
            message: 'Create your first match to get started.',
          ),
        ),
      ),
    );

    expect(find.text('No matches yet'), findsOneWidget);
    expect(
      find.text('Create your first match to get started.'),
      findsOneWidget,
    );
  });
}
