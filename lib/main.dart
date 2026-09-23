import 'package:flutter/material.dart';
import 'package:accessibility_widget/accessibility_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AccessibilityDemoApp());
}

/// Root application widget showcasing the accessibility widget package.
class AccessibilityDemoApp extends StatelessWidget {
  const AccessibilityDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accessibility Widget Demo',
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
      home: const AccessibilityWidget(
        child: AccessibilityShowcaseScreen(),
      ),
    );
  }
}

/// Interactive showcase screen to test and demonstrate all accessibility features.
class AccessibilityShowcaseScreen extends StatefulWidget {
  const AccessibilityShowcaseScreen({super.key});

  @override
  State<AccessibilityShowcaseScreen> createState() =>
      _AccessibilityShowcaseScreenState();
}

class _AccessibilityShowcaseScreenState
    extends State<AccessibilityShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AccessibilityScope scope = AccessibilityScope.of(context);
    final AccessibilitySettings settings = scope.settings;
    final AccessibilityController controller = scope.controller;
    final ThemeData theme = Theme.of(context);
    final bool animationsDisabled = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility Showcase'),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Accessibility Settings Page',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const AccessibilitySettingsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.layers_outlined),
            tooltip: 'Open Bottom Sheet',
            onPressed: () => AccessibilityBottomSheet.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reset Accessibility',
            onPressed: () {
              controller.reset();
              _showMessage('Accessibility settings reset to default');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: <Widget>[
          // Active Settings Summary Banner
          _buildStatusBanner(context, settings, controller),
          const SizedBox(height: 16),

          // Preset Profiles Section
          AccessibleTile(
            child: Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const AccessibleHeading(
                      level: 2,
                      child: Text('Preset Profiles'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap a profile to apply comprehensive accessibility adjustments designed for specific needs:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AccessibilityProfile.values.map((profile) {
                        final bool isSelected =
                            settings.activeProfile == profile;
                        final IconData icon;
                        switch (profile) {
                          case AccessibilityProfile.seizureSafe:
                            icon = Icons.flash_off;
                            break;
                          case AccessibilityProfile.visionImpaired:
                            icon = Icons.visibility;
                            break;
                          case AccessibilityProfile.adhd:
                            icon = Icons.center_focus_strong;
                            break;
                          case AccessibilityProfile.dyslexia:
                            icon = Icons.spellcheck;
                            break;
                        }
                        return ChoiceChip(
                          avatar: Icon(icon, size: 18),
                          label: Text(profile.label),
                          selected: isSelected,
                          onSelected: (_) {
                            final bool wasSelected = isSelected;
                            controller.applyProfile(profile);
                            if (wasSelected) {
                              _showMessage(
                                  'Disabled "${profile.label}" profile');
                            } else {
                              _showMessage(
                                  'Applied "${profile.label}" profile');
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Accessible Headings & Typography Section
          AccessibleTile(
            child: Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const AccessibleHeading(
                      level: 1,
                      child: Text('Typography & Headings'),
                    ),
                    const SizedBox(height: 8),
                    const AccessibleHeading(
                      level: 2,
                      child: Text('Heading Level 2 (Section Title)'),
                    ),
                    const SizedBox(height: 6),
                    const AccessibleHeading(
                      level: 3,
                      child: Text('Heading Level 3 (Subsection)'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This paragraph demonstrates text scaling, dynamic line spacing, letter spacing, font weighting, and dyslexia-friendly font adjustments. Enable "Highlight Headings" in the accessibility menu to see visual accent markers and increased contrast on headers.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Accessible Images Section
          AccessibleTile(
            child: Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const AccessibleHeading(
                      level: 2,
                      child: Text('Accessible Images (Hide Images Test)'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'When "Hide Images" is enabled in preferences, images are replaced with a high-contrast accessible placeholder with semantic labels:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    AccessibleImage(
                      semanticLabel:
                          'Sample nature photography illustrating mountains and forest',
                      height: 180,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Colors.teal.shade700,
                                Colors.indigo.shade800,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.landscape,
                                size: 72,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              Positioned(
                                bottom: 12,
                                child: Text(
                                  'Decorative Landscape Image',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Accessible Links & Interactive Elements Section
          AccessibleTile(
            child: Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const AccessibleHeading(
                      level: 2,
                      child: Text('Accessible Links & Haptics'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Links gain clear visual indicators and optional tactile haptic vibration feedback when tapped:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    AccessibleLink(
                      onTap: () =>
                          _showMessage('Tapped: WCAG 2.1 Guidelines Link'),
                      child:
                          const Text('Read WCAG 2.1 Accessibility Guidelines'),
                    ),
                    const SizedBox(height: 8),
                    AccessibleLink(
                      onTap: () =>
                          _showMessage('Tapped: Accessibility Statement'),
                      child: const Text(
                          'View App Accessibility Statement & Policy'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Motion & Animations Test Section
          AccessibleTile(
            child: Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const AccessibleHeading(
                      level: 2,
                      child: Text('Motion & Animation Control'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'When "Stop Animations" is toggled on, animations are automatically disabled via MediaQuery.disableAnimations:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: _animController,
                          builder: (context, child) {
                            final double angle = animationsDisabled
                                ? 0.0
                                : _animController.value * 2 * 3.14159;
                            return Transform.rotate(
                              angle: angle,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.sync,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            animationsDisabled
                                ? 'Status: Animations PAUSED (Reduce Motion active)'
                                : 'Status: Animations RUNNING smoothly',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: animationsDisabled
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Quick Action Launchers
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.accessibility_new),
                  label: const Text('Open Sheet'),
                  onPressed: () => AccessibilityBottomSheet.show(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Page'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const AccessibilitySettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(
    BuildContext context,
    AccessibilitySettings settings,
    AccessibilityController controller,
  ) {
    final ThemeData theme = Theme.of(context);
    final List<String> activeFeatures = <String>[];

    if (settings.textScale != 1.0) {
      activeFeatures.add('Text ${(settings.textScale * 100).toInt()}%');
    }
    if (settings.highContrast) activeFeatures.add('High Contrast');
    if (settings.invertColors) activeFeatures.add('Invert Colors');
    if (settings.saturation != 1.0) {
      activeFeatures.add('Sat ${(settings.saturation * 100).toInt()}%');
    }
    if (settings.readingGuide) activeFeatures.add('Reading Guide');
    if (settings.bigCursor) activeFeatures.add('Big Cursor');
    if (settings.highlightHeadings) activeFeatures.add('Highlight Headings');
    if (settings.highlightLinks) activeFeatures.add('Highlight Links');
    if (settings.highlightTiles) activeFeatures.add('Highlight Tiles');
    if (settings.hideImages) activeFeatures.add('Hide Images');
    if (settings.dyslexiaFont) activeFeatures.add('Dyslexia Font');
    if (settings.boldText) activeFeatures.add('Bold Text');
    if (settings.stopAnimations) activeFeatures.add('Reduced Motion');

    final String profileLabel = settings.activeProfile?.label ??
        (activeFeatures.isEmpty ? 'Default (Standard)' : 'Custom Settings');

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.accessibility,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Profile: $profileLabel',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              if (activeFeatures.isNotEmpty || settings.activeProfile != null)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => controller.reset(),
                  child: const Text('Reset'),
                ),
            ],
          ),
          if (activeFeatures.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: activeFeatures.map((feature) {
                return Chip(
                  label: Text(
                    feature,
                    style: theme.textTheme.labelSmall,
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
