import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String _themePreferenceKey = 'theme_preference';
  final String _themeSystemKey = 'system';
  final String _themeLightKey = 'light';
  final String _themeDarkKey = 'dark';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isSystemTheme => _themeMode == ThemeMode.system;
  bool get isLightTheme => _themeMode == ThemeMode.light;
  bool get isDarkTheme => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final themePreference =
        prefs.getString(_themePreferenceKey) ?? _themeSystemKey;

    if (themePreference == _themeLightKey) {
      _themeMode = ThemeMode.light;
    } else if (themePreference == _themeDarkKey) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    String themeModeValue;

    if (mode == ThemeMode.light) {
      themeModeValue = _themeLightKey;
    } else if (mode == ThemeMode.dark) {
      themeModeValue = _themeDarkKey;
    } else {
      themeModeValue = _themeSystemKey;
    }

    await prefs.setString(_themePreferenceKey, themeModeValue);
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.system);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  void setSystemTheme() {
    setThemeMode(ThemeMode.system);
  }

  void setLightTheme() {
    setThemeMode(ThemeMode.light);
  }

  void setDarkTheme() {
    setThemeMode(ThemeMode.dark);
  }
}
