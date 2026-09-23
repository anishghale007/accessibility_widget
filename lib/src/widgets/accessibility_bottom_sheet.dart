import 'dart:async';
import 'package:flutter/material.dart';
import '../controller/accessibility_controller.dart';
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
    EdgeInsets margin = const EdgeInsets.only(right: 16.0, bottom: 84.0, top: 16.0),
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
          final AccessibilityWidgetTheme resolvedTheme =
              theme?.resolveWith(dialogContext) ??
                  const AccessibilityWidgetTheme().resolveWith(dialogContext);

          return Stack(
            children: <Widget>[
              SafeArea(
                child: Align(
                  alignment: alignment,
                  child: Padding(
                    padding: margin,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 380,
                        constraints: BoxConstraints(
                          maxHeight:
                              MediaQuery.sizeOf(dialogContext).height * 0.82,
                          maxWidth:
                              MediaQuery.sizeOf(dialogContext).width - 32,
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
                        child: AccessibilityScope(
                          controller: controller,
                          theme: theme,
                          child: const AccessibilityBottomSheet(isPopup: true),
                        ),
                      ),
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
    final AccessibilityWidgetTheme theme = scope.theme?.resolveWith(context) ??
        const AccessibilityWidgetTheme().resolveWith(context);

    Widget buildPanelBody() {
      return Column(
        children: <Widget>[
          // Sheet Header
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: theme.panelHeaderColor,
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
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(theme.fabIcon,
                            color: theme.accentColor, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Accessibility',
                          style: theme.titleStyle ??
                              const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
              color: theme.panelHeaderColor,
              border: Border(
                top: BorderSide(
                  color:
                      Theme.of(context).dividerColor.withValues(alpha: 0.3),
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
                  label: const Text('Reset all to defaults'),
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
      );
    }

    if (isPopup) {
      return buildPanelBody();
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.70,
      minChildSize: 0.40,
      maxChildSize: 0.95,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.panelBackgroundColor,
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
