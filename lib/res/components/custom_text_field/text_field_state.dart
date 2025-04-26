import 'package:flutter/material.dart';

class TextFieldState extends ChangeNotifier {
  bool _hasError = false;
  bool _isFocused = false;

  bool get hasError => _hasError;
  bool get isFocused => _isFocused;

  void setError(bool value) {
    _hasError = value;
    notifyListeners();
  }

  void setFocus(bool value) {
    _isFocused = value;
    notifyListeners();
  }
}
