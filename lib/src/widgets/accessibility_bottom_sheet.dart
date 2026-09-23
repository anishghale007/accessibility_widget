import 'dart:async';
import 'package:flutter/material.dart';
import '../controller/accessibility_controller.dart';
import '../models/accessibility_settings.dart';
import '../theme/accessibility_widget_theme.dart';
import '../utils/platform.dart';
import 'accessibility_panel_content.dart';
import 'accessibility_scope.dart';

/// Modal bottom sheet and anchored web popup entry point for accessibility settings.
class AccessibilityBottomSheet extends StatelessWidget {
  const AccessibilityBottomSheet({
    super.key,
    this.isPopup = false,
  });

  /// Whether this is rendered as a desktop/web anchored popup card rather than a mobile modal sheet.
  final bool isPopup;

  /// Displays the modal accessibility preferences interface.
  ///
  /// On **Web**: Renders as an anchored floating card aligned to where the FAB is located.
  /// On **Mobile**: Renders as a smooth modal draggable bottom sheet.
  static Future<void> show(
    BuildContext context, {
    Alignment alignment = Alignment.bottomRight,
    EdgeInsets margin = const EdgeInsets.all(16.0),
  }) {
    final AccessibilityScope scope = AccessibilityScope.of(context);
    final AccessibilityController controller = scope.controller;
    final AccessibilityWidgetTheme? theme = scope.theme;
    final bool isWeb = PlatformInfo.current.isWeb;

    if (isWeb) {
      return showDialog<void>(
        context: context,
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
                      theme: theme,
                      child: const AccessibilityBottomSheet(isPopup: true),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return AccessibilityScope(
          controller: controller,
          theme: theme,
          child: const AccessibilityBottomSheet(isPopup: false),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AccessibilityScope scope = AccessibilityScope.of(context);
    final AccessibilitySettings settings = scope.settings;

    // Dynamically resolve brightness according to the current settings.darkMode preference
    final Brightness effectiveBrightness = settings.darkMode != null
        ? (settings.darkMode! ? Brightness.dark : Brightness.light)
        : Theme.of(context).brightness;

    final bool isDark = effectiveBrightness == Brightness.dark;

    final Color effectivePanelBg = scope.theme?.panelBackgroundColor ??
        (isDark ? const Color(0xFF1E1E1E) : Colors.white);
    final Color effectivePanelHeader = scope.theme?.panelHeaderColor ??
        (isDark ? const Color(0xFF282828) : const Color(0xFFF5F6FA));
    final Color effectiveCardBg = scope.theme?.cardBackgroundColor ??
        (isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEEF0F6));
    final Color effectiveAccent = scope.theme?.accentColor ??
        (isDark ? Colors.indigoAccent : Colors.indigo);

    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: effectiveAccent,
      brightness: effectiveBrightness,
    );

    final ThemeData dynamicTheme = (isDark
            ? ThemeData.dark(useMaterial3: true)
            : ThemeData.light(useMaterial3: true))
        .copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: effectivePanelBg,
      cardColor: effectiveCardBg,
    );

    final AccessibilityWidgetTheme resolvedTheme =
        (scope.theme ?? const AccessibilityWidgetTheme()).copyWith(
      panelBackgroundColor: effectivePanelBg,
      panelHeaderColor: effectivePanelHeader,
      cardBackgroundColor: effectiveCardBg,
      accentColor: effectiveAccent,
      fabBackgroundColor:
          scope.theme?.fabBackgroundColor ?? colorScheme.primary,
      fabForegroundColor:
          scope.theme?.fabForegroundColor ?? colorScheme.onPrimary,
    );

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
                color: resolvedTheme.panelHeaderColor,
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
                          color: dynamicTheme.dividerColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(resolvedTheme.fabIcon,
                              color: resolvedTheme.accentColor, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Accessibility',
                            style: resolvedTheme.titleStyle ??
                                TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: dynamicTheme.colorScheme.onSurface,
                                ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
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
                color: resolvedTheme.panelHeaderColor,
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
            color: resolvedTheme.panelBackgroundColor,
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
            color: resolvedTheme.panelBackgroundColor,
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
