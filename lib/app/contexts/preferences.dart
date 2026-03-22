import 'package:flutter/material.dart';
import 'package:knox/hive/worker_bee.dart';

class Preferences extends ChangeNotifier {
  late bool _darkMode;
  bool get darkMode => _darkMode;

  Preferences(Map<dynamic, dynamic> prefs) {
    _darkMode = prefs[PrefKeys.darkMode] as bool? ?? false;
  }

  void toggleDarkMode(bool boolean) async {
    _darkMode = boolean;
    await WorkerBee.addOrUpdateItem(PrefKeys.darkMode, _darkMode);
    notifyListeners();
  }
}

class PrefKeys {
  static final String darkMode = 'darkMode'; //Bool
}
