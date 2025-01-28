// date_utils.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateUtils {
  static Future<void> selectDate({
    required BuildContext context,
    required TextEditingController controller,
    DateTime? initialDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
}
