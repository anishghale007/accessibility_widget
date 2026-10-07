import 'dart:async';
import 'package:flutter/material.dart';
import '../controller/accessibility_controller.dart';
import '../models/accessibility_settings.dart';
import '../utils/platform.dart';
import 'accessibility_panel_content.dart';
import 'accessibility_scope.dart';

/// Modal bottom sheet and anchored web popup entry point for accessibility settings.
class AccessibilityBottomSheet extends StatelessWidget {
  const AccessibilityBottomSheet({
    super.key,
    this.isPopup = false,
  });

  /// Notifier indicating whether the accessibility preferences sheet/popup is currently open.
  static final ValueNotifier<bool> isOpenNotifier = ValueNotifier<bool>(false);

  /// Whether the accessibility preferences sheet/popup is currently open.
  static bool get isOpen => isOpenNotifier.value;

  /// Whether this is rendered as a desktop/web anchored popup card rather than a mobile modal sheet.
  final bool isPopup;

  /// Displays the modal accessibility preferences interface.
  ///
  /// On **Web**: Renders as an anchored floating card aligned to where the FAB is located.
  /// On **Mobile**: Renders as a smooth modal draggable bottom sheet.
  static Future<void> show(
    BuildContext context, {
    GlobalKey<NavigatorState>? navigatorKey,
    Alignment alignment = Alignment.bottomRight,
    EdgeInsets margin = const EdgeInsets.all(16.0),
  }) async {
    if (isOpen) return;
    isOpenNotifier.value = true;

    final BuildContext effectiveContext =
        navigatorKey?.currentContext ?? context;
    final AccessibilityScope scope = AccessibilityScope.of(effectiveContext);
    final AccessibilityController controller = scope.controller;
    final bool isWeb = PlatformInfo.current.isWeb;

    try {
      if (isWeb) {
        await showDialog<void>(
          context: effectiveContext,
          barrierColor: Colors.black26,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return Stack(
              children: <Widget>[
                SafeArea(
                  child: Align(
                    alignment: alignment,
                    child: Padding(
                      padding: margin,
                      child: AccessibilityScope(
                        controller: controller,
                        child: const AccessibilityBottomSheet(isPopup: true),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        await showModalBottomSheet<void>(
          context: effectiveContext,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext sheetContext) {
            return AccessibilityScope(
              controller: controller,
              child: const AccessibilityBottomSheet(isPopup: false),
            );
          },
        );
      }
    } finally {
      isOpenNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AccessibilityScope scope = AccessibilityScope.of(context);
    final AccessibilitySettings settings = scope.settings;
    final ThemeData ambientTheme = Theme.of(context);

    final Brightness effectiveBrightness = settings.darkMode != null
        ? (settings.darkMode! ? Brightness.dark : Brightness.light)
        : ambientTheme.brightness;

    final bool isDark = effectiveBrightness == Brightness.dark;

    final ThemeData baselineTheme = (isDark
            ? ThemeData.dark(useMaterial3: ambientTheme.useMaterial3)
            : ThemeData.light(useMaterial3: ambientTheme.useMaterial3))
        .copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: ambientTheme.colorScheme.primary,
        brightness: effectiveBrightness,
      ),
    );

    ColorScheme effectiveColorScheme = baselineTheme.colorScheme;
    if (settings.highContrast) {
      effectiveColorScheme = isDark
          ? ColorScheme.highContrastDark().copyWith(
              primary: const Color(0xFFFFD600),
              onPrimary: Colors.black,
              secondary: const Color(0xFF00E5FF),
              onSecondary: Colors.black,
              surface: Colors.black,
              onSurface: Colors.white,
              outline: Colors.white,
            )
          : ColorScheme.highContrastLight().copyWith(
              primary: const Color(0xFF002B7F),
              onPrimary: Colors.white,
              secondary: const Color(0xFF004D40),
              onSecondary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
              outline: Colors.black,
            );
    } else if (settings.darkMode == null &&
        ambientTheme.brightness == effectiveBrightness) {
      effectiveColorScheme = ambientTheme.colorScheme;
    }

    final TextTheme baseTextTheme = (settings.darkMode != null &&
            settings.darkMode != (ambientTheme.brightness == Brightness.dark))
        ? baselineTheme.textTheme
        : ambientTheme.textTheme;

    final ThemeData dynamicTheme = ambientTheme.copyWith(
      brightness: effectiveBrightness,
      colorScheme: effectiveColorScheme,
      textTheme: baseTextTheme,
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
    );

    final ColorScheme colorScheme = dynamicTheme.colorScheme;
    final Color panelBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color headerBg =
        isDark ? const Color(0xFF282828) : const Color(0xFFF5F6FA);

    Widget buildPanelBody() {
      return Theme(
        data: dynamicTheme,
        child: Column(
          children: <Widget>[
            // Sheet Header
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: headerBg,
                borderRadius: isPopup
                    ? null
                    : const BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: Column(
                children: <Widget>[
                  if (!isPopup)
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white30 : Colors.black26,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.accessibility_new,
                              color: colorScheme.primary, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Accessibility',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: colorScheme.onSurface,
                        tooltip: 'Close',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Scrollable Settings Content
            const Expanded(
              child: SingleChildScrollView(
                child: AccessibilityPanelContent(showResetButton: false),
              ),
            ),

            // Sticky Bottom Action Bar (Restore Defaults)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: headerBg,
                border: Border(
                  top: BorderSide(
                    color: dynamicTheme.dividerColor.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => scope.controller.reset(),
                    icon: const Icon(Icons.restore, size: 18),
                    label: const Text('Reset Settings'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (isPopup) {
      return Material(
        color: Colors.transparent,
        child: Container(
          width: 380,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.82,
            maxWidth: MediaQuery.sizeOf(context).width - 32,
          ),
          decoration: BoxDecoration(
            color: panelBg,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black38,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: buildPanelBody(),
        ),
      );
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.70,
      minChildSize: 0.40,
      maxChildSize: 0.95,
      builder: (BuildContext sheetInternalContext,
          ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: panelBg,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20.0)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: buildPanelBody(),
        );
      },
    );
  }
}
