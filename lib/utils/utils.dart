import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/utils/platform_toast.dart';

class Utils {
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void toastMessage(String message) {
    // Use platform-agnostic toast that works on Windows and Web
    PlatformToast.show(message);
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    snackBar(message, context);
  }

  static void snackBar(String message, BuildContext context) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(message),
        ),
      );
    }
  }
}
