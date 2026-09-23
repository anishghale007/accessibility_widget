# Accessibility Widget Example

A complete showcase application demonstrating all features provided by the [`accessibility_widget`](https://pub.dev/packages/accessibility_widget) package.

---

## Basic Implementation

Wrap your home screen or application tree with `AccessibilityWidget`:

```dart
import 'package:flutter/material.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accessible App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      // Wrap your main screen with AccessibilityWidget
      home: const AccessibilityWidget(
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessible App Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AccessibleHeading(
              level: 1,
              child: Text('Welcome'),
            ),
            const SizedBox(height: 8),
            const Text(
              'This text automatically responds to font scaling, line height, letter spacing, and dyslexia-friendly font adjustments.',
            ),
            const SizedBox(height: 16),
            AccessibleLink(
              onTap: () => AccessibilityBottomSheet.show(context),
              child: const Text('Open Accessibility Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Features Demonstrated

- ⚡ **Preset Profiles** — Live toggling between **Seizure Safe**, **Vision Impaired**, **ADHD Friendly**, and **Dyslexia Friendly** profiles.
- 🔤 **Typography & Headings** — Testing font scaling, line height, letter spacing, bold text, and the bundled **Andika** dyslexia-friendly font alongside `AccessibleHeading` (levels 1–3).
- 🖼️ **Image Hiding** — Demonstrating `AccessibleImage` with instant zero-space placeholder removal.
- 🔗 **Links & Haptics** — Demonstrating `AccessibleLink` with visual highlights and tactile feedback.
- 🃏 **Cards & Boundaries** — Testing `AccessibleTile` border outlines.
- ⏱️ **Motion Reduction** — Rotation animation demonstrating instant pausing via `MediaQuery.disableAnimations`.
- 🧭 **Overlays** — Reading Guide spotlight overlay and Big Cursor tracking on Web.
- 🌗 **Adaptive Appearance** — Switching between System, Light, and Dark themes.

---

## Running the Example

Navigate to the `example` directory and run the Flutter application:

```bash
cd example
flutter pub get
flutter run
```

To run specifically on Web:

```bash
flutter run -d chrome
```
