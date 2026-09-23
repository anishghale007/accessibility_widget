# Accessibility Widget

A comprehensive, non-invasive Flutter accessibility package providing WCAG 2.1-informed controls, preset profiles, dynamic typography scaling, high contrast, reading guide spotlight, and platform-adaptive preferences UI.

This package implements accessibility features informed by the [WCAG 2.1 AA Guidelines](https://www.w3.org/TR/WCAG21/), focusing on:

- [1.4.3 Contrast (Minimum)](https://www.w3.org/TR/WCAG21/#contrast-minimum)
- [1.4.4 Resize Text](https://www.w3.org/TR/WCAG21/#resize-text)
- [1.4.12 Text Spacing](https://www.w3.org/TR/WCAG21/#text-spacing)
- [2.3.3 Animation from Interactions](https://www.w3.org/TR/WCAG21/#animation-from-interactions)
- [2.4.6 Headings and Labels](https://www.w3.org/TR/WCAG21/#headings-and-labels)

---

## Features

- ⚡ **Preset Profiles** — One-tap profiles designed for specific needs (tap active profile again to toggle off):
  - **Seizure Safe** — Stops animations and reduces color saturation.
  - **Vision Impaired** — Enlarges text (1.5x), enables high contrast, bold text, big cursor, and highlights navigation.
  - **ADHD Friendly** — Focuses reading with a spotlight reading guide and stops animations.
  - **Dyslexia Friendly** — Applies the bundled **Andika** typeface, increases line height, expands letter spacing, and pauses animations.
- 🔤 **Text & Typography** — Granular text scaling (80% to 200%), bold weight, line spacing (1.0x to 2.5x), letter spacing, and dyslexia-friendly font.
- 🎨 **Color & Contrast** — High-contrast mode, full screen color inversion, color saturation slider (monochrome to saturated), and dynamic Light/Dark/System theme switching.
- 🖼️ **Image Control** — **Hide Images** mode that removes images with zero layout space taken (`AccessibleImage`).
- 🧭 **Navigation & Visual Aids**:
  - **Reading Guide Spotlight** — Dims background content while keeping the active reading line clear, with a draggable grip handle on mobile and instant cursor tracking on web.
  - **Big Cursor (Web)** — Enlarged high-contrast white cursor follower with a prominent black outline.
  - **Highlight Links** (`AccessibleLink`) — Outlines clickable links and adds visual link indicators.
  - **Highlight Headings** (`AccessibleHeading`) — Semantic header tagging with visual level accent bars.
  - **Highlight Tiles & Cards** (`AccessibleTile`) — Clear boundary outlines for tappable cards and list items.
- 📳 **Motion & Haptics** — Reduce Motion toggle (`MediaQuery.disableAnimations`) and optional tactile vibration feedback on mobile.
- 💾 **Automatic Persistence** — Settings are asynchronously persisted via `SharedPreferences` across app restarts, with a sticky "Reset Settings" button.
- 💻 **Adaptive Platform UI**:
  - **Mobile** — Draggable modal bottom sheet (`AccessibilityBottomSheet`).
  - **Web / Desktop** — Floating popup card anchored directly above the floating action button (FAB).
  - **Page Entry Point** — Full-screen `AccessibilitySettingsPage` for integration into existing settings menus.

---

## Getting Started

Add `accessibility_widget` to your `pubspec.yaml`:

```yaml
dependencies:
  accessibility_widget: ^0.0.1
```

Import the package in your Dart code:

```dart
import 'package:accessibility_widget/accessibility_widget.dart';
```

---

## Usage

### 1. Basic Setup

Wrap your application tree with `AccessibilityWidget`. It automatically injects the controller, applies typography and media query overrides, renders screen overlays, and displays a circular floating action button (FAB):

```dart
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
      home: const AccessibilityWidget(
        child: HomeScreen(),
      ),
    );
  }
}
```

---

### 2. Using Accessible Components

Use the bundled accessible wrapper widgets throughout your UI to take full advantage of accessibility preferences:

#### Accessible Headings
Enforces semantic header tags for screen readers and displays visual accent bars when heading highlights are enabled:

```dart
AccessibleHeading(
  level: 1, // Hierarchy level: 1 (h1) to 6 (h6)
  child: Text('Main Section Title'),
)
```

#### Accessible Images
Hides images completely with zero layout space when the user enables "Hide Images":

```dart
AccessibleImage(
  semanticLabel: 'Mountain landscape at sunrise',
  child: Image.network('https://example.com/photo.jpg'),
)
```

#### Accessible Links
Adds visual accent indicators and optional tactile haptic feedback on tap:

```dart
AccessibleLink(
  onTap: () => launchUrl(Uri.parse('https://flutter.dev')),
  child: const Text('Visit Flutter Website'),
)
```

#### Accessible Cards & Tiles
Highlights card boundaries and item borders when "Highlight Tiles & Cards" is enabled:

```dart
AccessibleTile(
  onTap: () => openDetails(),
  child: Card(
    child: ListTile(
      title: Text('Account Settings'),
      subtitle: Text('Manage your profile and privacy preferences'),
    ),
  ),
)
```

---

### 3. Programmatic Navigation & Dialogs

Open the accessibility preferences programmatically from your app bar, drawer, or existing settings menu:

#### Open Modal Bottom Sheet / Web Anchored Popup
```dart
// Opens as a modal bottom sheet on mobile, or as an anchored popup docked to the FAB on web
AccessibilityBottomSheet.show(context);
```

#### Navigate to Dedicated Settings Page
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const AccessibilitySettingsPage(),
  ),
);
```

#### Access Controller & Settings Directly
```dart
final scope = AccessibilityScope.of(context);
final controller = scope.controller;
final settings = scope.settings;

// Apply a preset profile
controller.applyProfile(AccessibilityProfile.dyslexia);

// Reset all settings to defaults
controller.reset();
```

---

### 4. Custom Theming

Customize the look and feel of the accessibility FAB, bottom sheet, and highlight accents using `AccessibilityWidgetTheme`:

```dart
AccessibilityWidget(
  theme: AccessibilityWidgetTheme(
    accentColor: Colors.deepPurple,
    fabBackgroundColor: Colors.deepPurple,
    fabForegroundColor: Colors.white,
    fabShape: const CircleBorder(),
  ),
  child: const HomeScreen(),
)
```

---

## A Note on App Size & Typography

To power the **Dyslexia Friendly** and low-vision accessibility mode, this package bundles the [Andika](https://software.sil.org/andika/) typeface (distributed under the [SIL Open Font License](https://openfontlicense.org/)), a font specifically engineered by SIL International for clear letter distinctions and high readability.

The package includes four styles (Regular, Bold, Italic, and Bold-Italic), which adds **~2.5 MB** to your overall asset bundle. When dyslexia mode is disabled, your app renders with its standard default font.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
