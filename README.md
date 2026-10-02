# Accessibility Widget

A comprehensive, non-invasive Flutter accessibility package providing WCAG 2.1-informed controls, preset profiles, dynamic typography scaling, high contrast, reading guide spotlight, and platform-adaptive preferences UI.

🌐 [Check out the web demo](https://anishghale007.github.io/accessibility_widget/)

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
- 🖼️ **Image Control** — **Hide Images** mode that hides images cleanly or swaps to a custom placeholder (`AccessibleImage`).
- 🧭 **Navigation & Visual Aids**:
  - **Reading Guide Spotlight** — Dims background content while keeping the active reading line clear, with a draggable grip handle on mobile and instant cursor tracking on web.
  - **Big Cursor (Web)** — Enlarged high-contrast white cursor follower with a prominent black outline.
  - **Highlight Links** (`AccessibleLink`) — Outlines clickable links and adds visual link indicators.
  - **Highlight Headings** (`AccessibleHeading`) — Semantic header tagging with visual level accent bars.
  - **Highlight Tiles & Cards** (`AccessibleTile`) — Clear boundary outlines for tappable cards and list items.
- 🎬 **Motion & Animations** (`AccessibleAnimation`) — Reduce Motion toggle (`MediaQuery.disableAnimations`), automatic `AnimationController` lifecycle management, and dynamic reactive builders.
- 📳 **Haptics** — Optional tactile vibration feedback on mobile when tapping interactive elements.
- 💾 **Automatic Persistence** — Settings are asynchronously persisted via `SharedPreferences` across app restarts, with a "Reset Settings" button.
- 💻 **Adaptive Platform UI**:
  - **Floating Action Button (`AccessibilityFloatingActionButton`)** — Easy entry point with customizable icon and styles.
  - **Mobile Bottom Sheet (`AccessibilityBottomSheet`)** — Draggable modal bottom sheet.
  - **Web / Desktop Popup** — Floating popup card anchored directly near the FAB.
  - **Full-Screen Settings Page (`AccessibilitySettingsPage`)** — Ready to push into any app navigation or settings menu.

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

## Theming Process

`AccessibilityWidget` adopts **zero-config theming**. You do not need any separate theme configuration class.

The widget automatically uses the `theme` and `darkTheme` defined in your `MaterialApp`. All accessibility preferences (high contrast, text scaling, font weighting, saturation, and dark mode override) seamlessly transform and adapt your ambient `ThemeData`.

```dart
MaterialApp(
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
```

---

## Accessing the Floating Action Button (FAB)

To give users quick access to accessibility preferences, place `AccessibilityFloatingActionButton` directly into the `floatingActionButton` property of your `Scaffold`:

```dart
Scaffold(
  appBar: AppBar(title: const Text('Home')),
  body: const HomeScreenBody(),
  floatingActionButton: const AccessibilityFloatingActionButton(),
)
```

### Customizing the FAB Icon & Style
You can customize the FAB's icon, colors, and shape via constructor properties:

```dart
AccessibilityFloatingActionButton(
  // Customize the icon (defaults to Icons.accessibility_new)
  icon: Icons.accessibility,
  
  // Custom colors (defaults to theme's colorScheme.primary / onPrimary)
  backgroundColor: Colors.deepPurple,
  foregroundColor: Colors.white,
  
  // Custom tooltip
  tooltip: 'Open accessibility controls',
  
  // Custom shape
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
)
```

---

## Accessing the Settings Page & Bottom Sheet

You can trigger the accessibility preferences through multiple UI entry points:

### 1. Modal Bottom Sheet / Anchored Web Popup
Open the modal preferences sheet programmatically from any button, menu, or app bar action:

```dart
AccessibilityBottomSheet.show(context);
```

### 2. Dedicated Settings Page (`AccessibilitySettingsPage`)
Push the full-screen settings page from your existing settings menu or drawer:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const AccessibilitySettingsPage(),
  ),
);
```

### 3. Controller & Scope
Access the current settings or manipulate them programmatically from anywhere in the widget tree:

```dart
final scope = AccessibilityScope.of(context);
final controller = scope.controller;
final settings = scope.settings;

// Apply a preset profile
controller.applyProfile(AccessibilityProfile.dyslexia);

// Toggle individual settings
controller.toggleHighContrast();
controller.setTextScale(1.4);

// Reset all settings to defaults
controller.reset();
```

---

## Accessible UI Components

Use the bundled accessible wrapper widgets throughout your application:

### Accessible Headings

Enforces semantic header tags for screen readers and displays visual accent bars when heading highlights are enabled:

```dart
AccessibleHeading(
  level: 1, // Hierarchy level: 1 (h1) to 6 (h6)
  child: Text('Main Section Title'),
)
```

### Accessible Images

Hides images cleanly (or renders an optional custom `placeholder`) when the user enables "Hide Images":

```dart
AccessibleImage(
  child: Image.network('https://example.com/photo.jpg'),
)
```

### Accessible Links

Adds visual accent indicators, underlines, and optional tactile haptic feedback on tap:

```dart
AccessibleLink(
  onTap: () => launchUrl(Uri.parse('https://flutter.dev')),
  child: const Text('Visit Flutter Website'),
)
```

### Accessible Cards & Tiles

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

### Accessible Animations & Motion

Automatically pauses animations or swaps to a static fallback when "Reduce Motion" is enabled:

```dart
// Basic fallback swapping:
AccessibleAnimation(
  fallback: const StaticBanner(),
  child: const RotatingBannerAnimation(),
)

// Dynamic builder pattern:
AccessibleAnimation.builder(
  controller: myAnimationController,
  builder: (context, isAnimating, child) {
    return isAnimating ? SpinningLogo(child: child) : StaticLogo(child: child);
  },
  child: const Logo(),
)
```

---

## A Note on App Size & Typography

To power the **Dyslexia Friendly** and low-vision accessibility mode, this package bundles the [Andika](https://software.sil.org/andika/) typeface (distributed under the [SIL Open Font License](https://openfontlicense.org/)), a font specifically engineered by SIL International for clear letter distinctions and high readability.

The package includes four styles (Regular, Bold, Italic, and Bold-Italic), which adds **~2.5 MB** to your overall asset bundle. When dyslexia mode is disabled, your app renders with its standard default font.

---

## Acknowledgements & Inspirations

This package was created with great inspiration from:
- [Accessible Web Demo](https://accessibleweb.pages.dev/)
- [accessibility Flutter package](https://pub.dev/packages/accessibility)

Special thanks to the authors and maintainers of these projects for their pioneering work and contributions to digital accessibility.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
