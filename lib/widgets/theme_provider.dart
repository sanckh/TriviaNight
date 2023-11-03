import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    _saveThemePreference(isOn);
  }

  void _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', isDarkMode);
  }

  void loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = prefs.getBool('darkTheme') ?? false ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
