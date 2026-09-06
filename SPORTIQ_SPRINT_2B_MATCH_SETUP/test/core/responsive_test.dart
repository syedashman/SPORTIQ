import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportiq/core/utils/responsive.dart';

void main() {
  Future<BuildContext> pumpWithSize(WidgetTester tester, Size size) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = size;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    late BuildContext capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    await tester.pump();

    return capturedContext;
  }

  testWidgets('classifies mobile width correctly', (tester) async {
    final context = await pumpWithSize(tester, const Size(390, 844));

    expect(Responsive.of(context), ScreenSize.mobile);
  });

  testWidgets('classifies tablet width correctly', (tester) async {
    final context = await pumpWithSize(tester, const Size(800, 1024));

    expect(Responsive.of(context), ScreenSize.tablet);
  });

  testWidgets('classifies desktop width correctly', (tester) async {
    final context = await pumpWithSize(tester, const Size(1440, 900));

    expect(Responsive.of(context), ScreenSize.desktop);
  });
}
