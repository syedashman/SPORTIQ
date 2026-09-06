import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportiq/shared/theme/theme.dart';
import 'package:sportiq/shared/widgets/buttons/primary_button.dart';

void main() {
  testWidgets('PrimaryButton renders label and responds to tap', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: PrimaryButton(
            label: 'Continue',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('PrimaryButton shows spinner and disables tap when loading', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: PrimaryButton(
            label: 'Continue',
            isLoading: true,
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(tapped, isFalse);
  });
}
