import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A utility class that fixes keyboard input issues on Windows desktop
class KeyboardFix {
  // Singleton pattern
  static final KeyboardFix _instance = KeyboardFix._();
  factory KeyboardFix() => _instance;
  KeyboardFix._();

  // Mapping of physical keys that have been pressed
  final Set<PhysicalKeyboardKey> _pressedKeys = <PhysicalKeyboardKey>{};

  /// Initialize the keyboard fix
  void initialize() {
    // Add a special global handler for keyboard events
    ServicesBinding.instance.keyboard.addHandler(_handleGlobalKey);
  }

  /// Global key handler to prevent duplicate key events
  bool _handleGlobalKey(KeyEvent event) {
    // Handle key down events
    if (event is KeyDownEvent) {
      // If this key is already marked as pressed, it's a duplicate event
      // Intercept it to prevent the assertion error
      if (_pressedKeys.contains(event.physicalKey)) {
        return true; // Handled, don't propagate
      }

      // Otherwise, mark this key as pressed
      _pressedKeys.add(event.physicalKey);
    }
    // Handle key up events
    else if (event is KeyUpEvent) {
      // Remove this key from our pressed keys set
      _pressedKeys.remove(event.physicalKey);
    }

    // Allow normal processing for all other events
    return false;
  }

  /// Wrap a widget with keyboard focus handling
  Widget wrapWithKeyboardFix(Widget child, {FocusNode? focusNode}) {
    return Focus(
      focusNode: focusNode,
      onKeyEvent: (node, event) {
        // For text input fields, just ignore all key event handling
        if (node.context != null) {
          final FocusNode? primaryFocus = FocusManager.instance.primaryFocus;
          if (primaryFocus != null &&
              primaryFocus.context != null &&
              (primaryFocus.context!.widget is EditableText ||
                  primaryFocus.context!.widget
                      .toString()
                      .contains('TextField'))) {
            return KeyEventResult.ignored;
          }
        }

        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}
