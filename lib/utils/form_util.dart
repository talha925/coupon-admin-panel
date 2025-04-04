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

  /// Validates     the description field.
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

  // Debug method to help with validation
  static void logValidationInfo(Map<String, dynamic> data) {
    print('Validating store data: ${data.keys.join(", ")}');

    if (data.containsKey('directUrl')) {
      final url = data['directUrl'];
      final uri = Uri.tryParse(url);
      print('Direct URL: $url');
      print('  - Is absolute: ${uri?.isAbsolute}');
      print('  - Scheme: ${uri?.scheme}');
      print('  - Host: ${uri?.host}');
      print('  - Path: ${uri?.path}');
    }

    if (data.containsKey('trackingUrl')) {
      final url = data['trackingUrl'];
      final uri = Uri.tryParse(url);
      print('Tracking URL: $url');
      print('  - Is absolute: ${uri?.isAbsolute}');
      print('  - Scheme: ${uri?.scheme}');
      print('  - Host: ${uri?.host}');
      print('  - Path: ${uri?.path}');
    }

    if (data.containsKey('heading')) {
      final heading = data['heading'];
      print('Heading: $heading');
      print('  - Is allowed: ${ALLOWED_HEADINGS.contains(heading)}');
    }
  }

  // Add more form-related utility functions as needed...
}
