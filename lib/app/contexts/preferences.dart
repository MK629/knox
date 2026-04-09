import 'package:flutter/material.dart';
import 'package:knox/hive/worker_bee.dart';

class Preferences extends ChangeNotifier {
  late bool _darkMode;
  late String _currency;

  bool get darkMode => _darkMode;
  String get currency => _currency;

  Preferences(Map<dynamic, dynamic> prefs) {
    _darkMode = prefs[PrefKeys.darkMode] as bool? ?? false;
    _currency = prefs[PrefKeys.currency] as String? ?? "";
  }

  void toggleDarkMode(bool boolean) async {
    _darkMode = boolean;
    await WorkerBee.addOrUpdateItem(PrefKeys.darkMode, _darkMode);
    notifyListeners();
  }
}

class PrefKeys {
  static final String darkMode = 'darkMode';
  static final String currency = 'currency';
}
