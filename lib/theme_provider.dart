import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const THEME_STATUS = "THEME_STATUS";
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
    prefs.setBool(THEME_STATUS, value);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _darkTheme = prefs.getBool(THEME_STATUS) ?? false;
    notifyListeners();
  }

  void toggleTheme() {
    darkTheme = !darkTheme;
  }
}
