import 'package:flutter/material.dart';
import '../controller/accessibility_controller.dart';
import '../models/accessibility_profile.dart';
import '../models/accessibility_settings.dart';
import '../theme/accessibility_widget_theme.dart';
import '../utils/platform.dart';
import 'accessibility_scope.dart';

/// Shell-agnostic settings content widget displaying all accessibility toggles and sliders.
///
/// Embedded identically by both the FAB bottom sheet ([AccessibilityBottomSheet])
/// and the dedicated full-page screen ([AccessibilitySettingsPage]).
class AccessibilityPanelContent extends StatelessWidget {
  const AccessibilityPanelContent({
    super.key,
    this.platform = PlatformInfo.current,
    this.showResetButton = true,
  });

  /// Platform helper used to conditionally show web-only controls (e.g. Big Cursor).
  final PlatformInfo platform;

  /// Whether to show the bottom reset button at the end of the scroll list.
  final bool showResetButton;

  @override
  Widget build(BuildContext context) {
    final AccessibilityScope scope = AccessibilityScope.of(context);
    final AccessibilityController controller = scope.controller;
    final AccessibilitySettings settings = scope.settings;
    final AccessibilityWidgetTheme theme = scope.theme?.resolveWith(context) ??
        const AccessibilityWidgetTheme().resolveWith(context);

    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      children: <Widget>[
        // 1. Profiles Section
        _buildSectionHeader(
            context, theme, 'Profiles', Icons.auto_awesome_outlined),
        _buildProfilesSection(context, controller, settings, theme),
        const SizedBox(height: 16),

        // 2. Text Section
        _buildSectionHeader(
            context, theme, 'Text & Typography', Icons.text_fields_outlined),
        _buildSliderTile(
          context: context,
          theme: theme,
          title: 'Text Size',
          value: settings.textScale,
          min: 0.8,
          max: 2.0,
          divisions: 12,
          valueLabel: '${(settings.textScale * 100).round()}%',
          onChanged: controller.setTextScale,
        ),
        _buildSwitchTile(
          context: context,
          theme: theme,
          title: 'Bold Text',
          subtitle: 'Increases font weight for easier reading',
          value: settings.boldText,
          onChanged: (_) => controller.toggleBoldText(),
        ),
        _buildSwitchTile(
          context: context,
          theme: theme,
          title: 'Dyslexia Friendly Font',
          subtitle: 'Uses typography designed for readability',
          value: settings.dyslexiaFont,
          onChanged: (_) => controller.toggleDyslexiaFont(),
        ),
        _buildSliderTile(
          context: context,
          theme: theme,
          title: 'Line Spacing',
          value: settings.lineSpacing,
          min: 1.0,
          max: 2.5,
          divisions: 6,
          valueLabel: '${settings.lineSpacing.toStringAsFixed(1)}x',
          onChanged: controller.setLineSpacing,
        ),
        _buildSliderTile(
          context: context,
          theme: theme,
          title: 'Letter Spacing',
          value: settings.letterSpacing,
          min: 0.0,
          max: 4.0,
          divisions: 8,
          valueLabel: '+${settings.letterSpacing.toStringAsFixed(1)}px',
          onChanged: controller.setLetterSpacing,
        ),
        const SizedBox(height: 16),

        // 3. Color & Contrast Section
        _buildSectionHeader(
            context, theme, 'Color & Contrast', Icons.contrast_outlined),
        _buildSwitchTile(
          context: context,
          theme: theme,
          title: 'High Contrast',
          subtitle: 'Enhances contrast ratio for content and borders',
          value: settings.highContrast,
          onChanged: (_) => controller.toggleHighContrast(),
        ),
        _buildSwitchTile(
          context: context,
          theme: theme,
          title: 'Invert Colors',
          subtitle: 'Inverts colors across the entire application',
          value: settings.invertColors,
          onChanged: (_) => controller.toggleInvertColors(),
        ),
        _buildSliderTile(
          context: context,
          theme: theme,
          title: 'Color Saturation',
          value: settings.saturation,
          min: 0.0,
          max: 2.0,
          divisions: 8,
          valueLabel: settings.saturation == 0.0
              ? 'Monochrome'
              : '${(settings.saturation * 100).round()}%',
          onChanged: controller.setSaturation,
        ),
        _buildDarkModeOverrideTile(context, controller, settings, theme),
        const SizedBox(height: 16),

        // 4. Images Section
        _buildSectionHeader(context, theme, 'Images', Icons.image_outlined),
        _buildSwitchTile(
          context: context,
          theme: theme,
          title: 'Hide Images',
          subtitle:
              'Replaces images with placeholders to reduce cognitive clutter',
          value: settings.hideImages,
          onChanged: (_) => controller.toggleHideImages(),
        ),
        const SizedBox(height: 16),

        // 5. Navigation Aids Section
        _buildSectionHeader(
            context, theme, 'Navigation Aids', Icons.navigation_outlined),
        _buildSwitchTile(
          context: context,
          theme: theme,
          title: 'Highlight Links',
          subtitle: 'Adds underlines and clear color highlights to links',
          value: settings.highlightLinks,
          onChanged: (_) => controller.toggleHighlightLinks(),
        ),
        _buildSwitchTile(
          context: context,
          theme: theme,
          title: 'Highlight Tiles & Cards',
          subtitle: 'Outlines tappable list items, cards, and boundaries',
          value: settings.highlightTiles,
          onChanged: (_) => controller.toggleHighlightTiles(),
        ),
        _buildSwitchTile(
          context: context,
          theme: theme,
          title: 'Highlight Headings',
          subtitle: 'Visually emphasizes section titles and headings',
          value: settings.highlightHeadings,
          onChanged: (_) => controller.toggleHighlightHeadings(),
        ),
        _buildSwitchTile(
          context: context,
          theme: theme,
          title: 'Reading Guide',
          subtitle: platform.isWeb
              ? 'Displays a horizontal guide that follows your mouse'
              : 'Displays a horizontal guide with a draggable position handle',
          value: settings.readingGuide,
          onChanged: (_) => controller.toggleReadingGuide(),
        ),
        if (platform.isWeb)
          _buildSwitchTile(
            context: context,
            theme: theme,
            title: 'Big Cursor',
            subtitle: 'Enlarges the mouse pointer for better tracking',
            value: settings.bigCursor,
            onChanged: (_) => controller.toggleBigCursor(),
          ),
        const SizedBox(height: 16),

        // 6. Motion Section
        _buildSectionHeader(
          context,
          theme,
          'Motion & Animations',
          Icons.motion_photos_off_outlined,
        ),
        _buildSwitchTile(
          context: context,
          theme: theme,
          title: 'Reduce Motion',
          subtitle: 'Stops animations and page transitions',
          value: settings.stopAnimations,
          onChanged: (_) => controller.toggleReduceMotion(),
        ),
        const SizedBox(height: 16),

        // 7. Feedback Section (Mobile only)
        if (!platform.isWeb) ...<Widget>[
          _buildSectionHeader(
            context,
            theme,
            'Feedback',
            Icons.vibration_outlined,
          ),
          _buildSwitchTile(
            context: context,
            theme: theme,
            title: 'Haptic Feedback',
            subtitle:
                'Provides physical vibration confirmation on tap (mobile)',
            value: settings.hapticFeedback,
            onChanged: (_) => controller.toggleHapticFeedback(),
          ),
          const SizedBox(height: 16),
        ],

        // 8. Reset Button (Conditionally rendered when not docked stickily)
        if (showResetButton) ...<Widget>[
          _buildResetButton(context, controller, theme),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    AccessibilityWidgetTheme theme,
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20, color: theme.accentColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.sectionTitleStyle ??
                TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: theme.accentColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilesSection(
    BuildContext context,
    AccessibilityController controller,
    AccessibilitySettings settings,
    AccessibilityWidgetTheme theme,
  ) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: _buildProfileCard(
                context: context,
                title: AccessibilityProfile.seizureSafe.label,
                description: AccessibilityProfile.seizureSafe.description,
                icon: Icons.shield_outlined,
                isSelected:
                    settings.activeProfile == AccessibilityProfile.seizureSafe,
                onTap: () =>
                    controller.applyProfile(AccessibilityProfile.seizureSafe),
                theme: theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildProfileCard(
                context: context,
                title: AccessibilityProfile.visionImpaired.label,
                description: AccessibilityProfile.visionImpaired.description,
                icon: Icons.visibility_outlined,
                isSelected: settings.activeProfile ==
                    AccessibilityProfile.visionImpaired,
                onTap: () => controller
                    .applyProfile(AccessibilityProfile.visionImpaired),
                theme: theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildProfileCard(
                context: context,
                title: AccessibilityProfile.adhd.label,
                description: AccessibilityProfile.adhd.description,
                icon: Icons.center_focus_strong_outlined,
                isSelected: settings.activeProfile == AccessibilityProfile.adhd,
                onTap: () => controller.applyProfile(AccessibilityProfile.adhd),
                theme: theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildProfileCard(
                context: context,
                title: AccessibilityProfile.dyslexia.label,
                description: AccessibilityProfile.dyslexia.description,
                icon: Icons.spellcheck_outlined,
                isSelected:
                    settings.activeProfile == AccessibilityProfile.dyslexia,
                onTap: () =>
                    controller.applyProfile(AccessibilityProfile.dyslexia),
                theme: theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required AccessibilityWidgetTheme theme,
  }) {
    final Color borderColor = isSelected
        ? (theme.accentColor ?? Theme.of(context).colorScheme.primary)
        : Colors.transparent;

    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected
          ? (theme.accentColor?.withValues(alpha: 0.12) ??
              Theme.of(context).colorScheme.primaryContainer)
          : theme.cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    icon,
                    size: 20,
                    color: isSelected
                        ? (theme.accentColor ??
                            Theme.of(context).colorScheme.primary)
                        : Theme.of(context).iconTheme.color,
                  ),
                  const Spacer(),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      size: 18,
                      color: theme.accentColor ??
                          Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style:
                    TextStyle(fontSize: 11, color: Theme.of(context).hintColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required AccessibilityWidgetTheme theme,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      title: Text(title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
      value: value,
      activeThumbColor: theme.accentColor,
      contentPadding: EdgeInsets.zero,
      onChanged: onChanged,
    );
  }

  Widget _buildSliderTile({
    required BuildContext context,
    required AccessibilityWidgetTheme theme,
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String valueLabel,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              Text(
                valueLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: theme.accentColor,
                ),
              ),
            ],
          ),
          Slider.adaptive(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            activeColor: theme.accentColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDarkModeOverrideTile(
    BuildContext context,
    AccessibilityController controller,
    AccessibilitySettings settings,
    AccessibilityWidgetTheme theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Theme Appearance',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          SegmentedButton<bool?>(
            segments: const <ButtonSegment<bool?>>[
              ButtonSegment<bool?>(
                value: null,
                label: Text('System', style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.settings_suggest, size: 16),
              ),
              ButtonSegment<bool?>(
                value: false,
                label: Text('Light', style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.light_mode, size: 16),
              ),
              ButtonSegment<bool?>(
                value: true,
                label: Text('Dark', style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.dark_mode, size: 16),
              ),
            ],
            selected: <bool?>{settings.darkMode},
            onSelectionChanged: (Set<bool?> selection) {
              controller.setDarkMode(selection.first);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(
    BuildContext context,
    AccessibilityController controller,
    AccessibilityWidgetTheme theme,
  ) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: controller.reset,
        icon: const Icon(Icons.restore, size: 18),
        label: const Text('Reset all to defaults'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
