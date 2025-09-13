import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const themeStatus = "THEME_STATUS";
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  ThemeProvider() {
    _loadTheme();
  }

  set darkTheme(bool value) {
    _darkTheme = value;
    _saveTheme(value);
    notifyListeners();
  }

  void _saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeStatus, value);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _darkTheme = prefs.getBool(themeStatus) ?? false;
    notifyListeners();
  }

  void toggleTheme() {
    darkTheme = !darkTheme;
  }
}
