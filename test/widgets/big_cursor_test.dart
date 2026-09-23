import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('BigCursorOverlay', () {
    testWidgets('renders plain child without MouseRegion cursor hiding on non-web', (WidgetTester tester) async {
      PlatformInfo.debugIsWebOverride = false;

      addTearDown(() {
        PlatformInfo.debugIsWebOverride = null;
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BigCursorOverlay(
              platform: PlatformInfo(),
              child: Text('Non-Web View'),
            ),
          ),
        ),
      );

      expect(find.text('Non-Web View'), findsOneWidget);
    });

    testWidgets('uses MouseCursor.none on web platform', (WidgetTester tester) async {
      PlatformInfo.debugIsWebOverride = true;

      addTearDown(() {
        PlatformInfo.debugIsWebOverride = null;
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BigCursorOverlay(
              platform: PlatformInfo(),
              child: Text('Web Cursor View'),
            ),
          ),
        ),
      );

      expect(find.text('Web Cursor View'), findsOneWidget);
      final MouseRegion mouseRegion = tester.widget<MouseRegion>(find.byType(MouseRegion));
      expect(mouseRegion.cursor, SystemMouseCursors.none);
    });
  });
}
