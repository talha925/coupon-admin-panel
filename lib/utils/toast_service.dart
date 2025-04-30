import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// For mobile platforms
import 'package:fluttertoast/fluttertoast.dart' as mobile;

/// A platform-agnostic toast service that works across all platforms
class ToastService {
  // Singleton instance
  static final ToastService _instance = ToastService._internal();
  factory ToastService() => _instance;
  ToastService._internal();

  // Global key for accessing Scaffold on web/desktop platforms
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Show a toast message across all platforms
  void showToast({
    required String message,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 16.0,
    int timeInSeconds = 2,
    ToastGravity gravity = ToastGravity.bottom,
  }) {
    // On mobile platforms: use Fluttertoast plugin
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      try {
        mobile.Fluttertoast.showToast(
          msg: message,
          toastLength: mobile.Toast.LENGTH_SHORT,
          gravity: _getMobileGravity(gravity),
          timeInSecForIosWeb: timeInSeconds,
          backgroundColor: backgroundColor,
          textColor: textColor,
          fontSize: fontSize,
        );
      } catch (e) {
        // Fallback to SnackBar if plugin fails
        _showFallbackToast(message, backgroundColor, textColor, timeInSeconds);
      }
    }
    // On web or desktop: use SnackBar
    else {
      _showFallbackToast(message, backgroundColor, textColor, timeInSeconds);
    }
  }

  /// Fallback toast implementation using SnackBar
  void _showFallbackToast(
      String message, Color backgroundColor, Color textColor, int seconds) {
    // First try to use the scaffold messenger key
    if (scaffoldMessengerKey.currentState != null) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: textColor)),
          backgroundColor: backgroundColor,
          duration: Duration(seconds: seconds),
        ),
      );
    }
    // If not available, print to console in debug mode
    else if (kDebugMode) {
      print('Toast: $message');
    }
  }

  /// Show a platform-agnostic snackbar
  void showSnackBar(BuildContext context, String message,
      {Color backgroundColor = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Convert ToastGravity to mobile Fluttertoast gravity
  mobile.ToastGravity _getMobileGravity(ToastGravity gravity) {
    switch (gravity) {
      case ToastGravity.top:
        return mobile.ToastGravity.TOP;
      case ToastGravity.center:
        return mobile.ToastGravity.CENTER;
      case ToastGravity.bottom:
        return mobile.ToastGravity.BOTTOM;
    }
  }
}

/// Toast position enum (platform-agnostic)
enum ToastGravity {
  top,
  center,
  bottom,
}
