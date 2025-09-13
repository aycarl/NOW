import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const maxBellsStatus = "MAX_BELLS_STATUS";
  int _maxBells = 10;

  int get maxBells => _maxBells;

  SettingsProvider() {
    _loadMaxBells();
  }

  set maxBells(int value) {
    _maxBells = value;
    _saveMaxBells(value);
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
}
