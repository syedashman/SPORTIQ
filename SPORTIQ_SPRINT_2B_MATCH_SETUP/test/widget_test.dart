import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportiq/app/app_router.dart';
import 'package:sportiq/shared/theme/theme.dart';

void main() {
  testWidgets('App boots and renders the SPORTIQ splash screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.darkTheme,
          routerConfig: appRouter,
        ),
      ),
    );

    // GoRouter aur splash ki initial animation ko render hone do.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('SPORTIQ'), findsOneWidget);
    expect(
      find.text('E V E R Y   M A T C H   M A T T E R S .'),
      findsOneWidget,
    );
  });
}
