import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A utility class to handle keyboard events and prevent the
/// "A KeyDownEvent is dispatched, but the state shows that the physical key is already pressed" error.
class KeyboardEventHandler {
  // Singleton instance
  static final KeyboardEventHandler _instance =
      KeyboardEventHandler._internal();
  factory KeyboardEventHandler() => _instance;
  KeyboardEventHandler._internal();

  // Track pressed keys to avoid duplicate key down events
  final Set<PhysicalKeyboardKey> _pressedKeys = {};

  // List of problematic keys that often cause issues (Alt keys are common culprits)
  final Set<PhysicalKeyboardKey> _problemKeys = {
    PhysicalKeyboardKey.altLeft,
    PhysicalKeyboardKey.altRight,
    PhysicalKeyboardKey.metaLeft,
    PhysicalKeyboardKey.metaRight,
  };

  /// Initialize global key event handlers
  void initialize() {
    // Add a low-level key event handler service for the entire app
    ServicesBinding.instance.keyboard.addHandler(_handleGlobalKeyEvent);
  }

  /// Global key handler that runs before all others
  bool _handleGlobalKeyEvent(KeyEvent event) {
    // Focus on problem keys that often cause issues
    if (_problemKeys.contains(event.physicalKey)) {
      if (event is KeyDownEvent) {
        // If this problem key is already in our pressed keys set,
        // intercept it to prevent the duplicate KeyDownEvent assertion
        if (_pressedKeys.contains(event.physicalKey)) {
          return true; // Handle the event (prevent propagation)
        }
        _pressedKeys.add(event.physicalKey);
      } else if (event is KeyUpEvent) {
        _pressedKeys.remove(event.physicalKey);
      }
    }

    // Let other keys proceed normally
    return false;
  }

  /// Handle keyboard events to prevent duplicate KeyDownEvents
  KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      // If this key is already in our pressed keys set, ignore the duplicate KeyDownEvent
      if (_pressedKeys.contains(event.physicalKey)) {
        // Return handled to prevent the event from propagating and causing the assertion error
        return KeyEventResult.handled;
      }

      // Otherwise, add this key to our tracked pressed keys
      _pressedKeys.add(event.physicalKey);

      // Allow the event to propagate normally
      return KeyEventResult.ignored;
    } else if (event is KeyUpEvent) {
      // Remove the key from our pressed keys set when it's released
      _pressedKeys.remove(event.physicalKey);
      return KeyEventResult.ignored;
    }

    // For other key events, just pass them through
    return KeyEventResult.ignored;
  }

  /// Clear all pressed keys (useful when focus changes or to reset state)
  void clearPressedKeys() {
    _pressedKeys.clear();
  }
}

/// A widget that wraps content with keyboard event handling
class KeyboardEventHandlerWidget extends StatelessWidget {
  final Widget child;
  final FocusNode? focusNode;
  final bool autofocus;

  const KeyboardEventHandlerWidget({
    Key? key,
    required this.child,
    this.focusNode,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      onKeyEvent: KeyboardEventHandler().handleKeyEvent,
      child: child,
    );
  }
}
