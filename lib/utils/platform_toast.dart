import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Conditionally import fluttertoast only on mobile platforms
// This prevents MissingPluginException on desktop/web
class PlatformToast {
  static final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Access the messenger key for MaterialApp
  static GlobalKey<ScaffoldMessengerState> get messengerKey => _messengerKey;

  // Show toast using platform-appropriate method
  static void show(
    String message, {
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 2),
  }) {
    // Use SnackBar for desktop and web platforms
    if (_messengerKey.currentState != null) {
      // Cancel any existing snackbars first
      _messengerKey.currentState!.clearSnackBars();

      // Show new snackbar
      _messengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: textColor)),
          backgroundColor: backgroundColor,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      // Fallback to console in debug mode
      debugPrint('Toast: $message');
    }
  }
}
