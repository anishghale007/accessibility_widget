import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  group('ReadingGuideOverlay', () {
    testWidgets('renders drag handle on mobile platform', (WidgetTester tester) async {
      PlatformInfo.debugIsWebOverride = false;
      PlatformInfo.debugIsMobileOverride = true;

      addTearDown(() {
        PlatformInfo.debugIsWebOverride = null;
        PlatformInfo.debugIsMobileOverride = null;
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ReadingGuideOverlay(
              platform: PlatformInfo(),
              child: Text('Underlying Reading Content'),
            ),
          ),
        ),
      );

      expect(find.text('Underlying Reading Content'), findsOneWidget);
      expect(find.byIcon(Icons.drag_handle), findsOneWidget);

      // Drag the handle vertically
      await tester.drag(find.byIcon(Icons.drag_handle), const Offset(0, 50));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.drag_handle), findsOneWidget);
    });

    testWidgets('does not render mobile drag handle on web platform', (WidgetTester tester) async {
      PlatformInfo.debugIsWebOverride = true;
      PlatformInfo.debugIsMobileOverride = false;

      addTearDown(() {
        PlatformInfo.debugIsWebOverride = null;
        PlatformInfo.debugIsMobileOverride = null;
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ReadingGuideOverlay(
              platform: PlatformInfo(),
              child: Text('Web Reading Content'),
            ),
          ),
        ),
      );

      expect(find.text('Web Reading Content'), findsOneWidget);
      expect(find.byIcon(Icons.drag_handle), findsNothing);
    });
  });
}
