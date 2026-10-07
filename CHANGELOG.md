# Changelog

## 0.0.2

- **Accessible Animations Widget**: Added `AccessibleAnimation` to declaratively handle motion reduction with animated children and customizable static fallbacks.
- **Multi-Select Preset Profiles**: Enabled simultaneous multi-selection of accessibility profiles (e.g. combining Seizure Safe, ADHD Friendly, Dyslexia Friendly, and Vision Impaired at the same time).
- **Theme Brightness & Contrast Fix**: Fixed ambient `ThemeData` brightness resolution to prevent light mode apps from inadvertently switching into dark mode when profiles or settings are applied on dark OS platforms.
- **Enhanced ChoiceChip & Profile Styling**: Improved high-contrast colors and borders across Light and Dark themes.
- **Accessible Image Enhancement**: Cleanly collapses space when images are hidden without requiring a custom placeholder.

## 0.0.1

- Initial release of `accessibility_widget`.
- Preset accessibility profiles: Seizure Safe, Vision Impaired, ADHD Friendly, and Dyslexia Friendly.
- Granular text & typography adjustments: font scaling, bold text, line spacing, letter spacing, and bundled Andika dyslexia font.
- Color & contrast modes: high contrast, full screen color inversion, saturation slider, and dark mode override.
- Reading guide spotlight overlay with draggable grip handle (mobile) and cursor tracking (web).
- Big cursor follower for web and desktop platforms.
- Semantic components: `AccessibleHeading`, `AccessibleImage`, `AccessibleLink`, `AccessibleAnimation` and `AccessibleTile`.
- Adaptive UI: `AccessibilityFloatingActionButton`, draggable modal `AccessibilityBottomSheet`, anchored web popup, and full-page `AccessibilitySettingsPage`.
- Asynchronous settings persistence via `shared_preferences`.
