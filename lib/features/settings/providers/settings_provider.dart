import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const maxBellsStatus = "MAX_BELLS_STATUS";
  static const showAngelNumbersStatus = "SHOW_ANGEL_NUMBERS_STATUS";
  int _maxBells = 10;
  bool _showAngelNumbers = false;

  int get maxBells => _maxBells;
  bool get showAngelNumbers => _showAngelNumbers;

  SettingsProvider() {
    _loadMaxBells();
    _loadShowAngelNumbers();
  }

  set maxBells(int value) {
    _maxBells = value;
    _saveMaxBells(value);
    notifyListeners();
  }

  set showAngelNumbers(bool value) {
    _showAngelNumbers = value;
    _saveShowAngelNumbers(value);
    notifyListeners();
  }

  void _saveMaxBells(int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(maxBellsStatus, value);
  }

  void _loadMaxBells() async {
    final prefs = await SharedPreferences.getInstance();
    _maxBells = prefs.getInt(maxBellsStatus) ?? 10;
    notifyListeners();
  }

  void _saveShowAngelNumbers(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(showAngelNumbersStatus, value);
  }

  void _loadShowAngelNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    _showAngelNumbers = prefs.getBool(showAngelNumbersStatus) ?? false;
    notifyListeners();
  }
}
