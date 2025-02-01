// lib/utils/form_utils.dart

class FormUtils {
  /// Validates if the field is not empty.
  static String? validateRequiredField(String? value,
      {String errorMessage = 'This field is required'}) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  static String? validateWebsite(String? value) {
    const urlPattern =
        r'^(https?:\/\/)?(www\.)?([\da-z.-]+)\.([a-z.]{2,6})([\/\w .-]*)*\/?$';
    final regex = RegExp(urlPattern);

    if (value == null || value.isEmpty) {
      return 'Please enter the website';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Validates the description field.
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the description';
    }
    return null;
  }

  // Add more form-related utility functions as needed...
}
