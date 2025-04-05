// lib/utils/form_utils.dart

class FormUtils {
  /// The definitive list of allowed heading values - MUST match backend validation exactly
  static const List<String> ALLOWED_HEADINGS = [
    'Promo Codes & Coupon',
    'Coupons & Promo Codes',
    'Voucher & Discount Codes'
  ];

  /// Validates if the field is not empty.
  static String? validateRequiredField(String? value,
      {String errorMessage = 'This field is required'}) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  /// Validates if the URL is valid and has a complete path.
  static String? validateWebsite(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the website URL';
    }

    return null; // ✅ No format restrictions
  }

  /// Validates the description field.
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the description';
    }
    return null;
  }

  /// Validates the heading to ensure it matches one of the allowed values.
  static String? validateHeading(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a heading';
    }

    if (!ALLOWED_HEADINGS.contains(value)) {
      return 'Heading must be one of the allowed values';
    }

    return null;
  }

  /// Debug method — intentionally left empty for production
  static void logValidationInfo(Map<String, dynamic> data) {
    // Debug info disabled for production
  }
}
