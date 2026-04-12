import 'package:flutter/material.dart';
import 'package:knox/db/constants.dart';
import 'package:knox/hive/worker_bee.dart';

class Preferences extends ChangeNotifier {
  late bool _darkMode;
  late String _currency;

  bool get darkMode => _darkMode;
  String get currency => _currency;

  Preferences(Map<dynamic, dynamic> prefs) {
    _darkMode = prefs[PrefKeys.darkMode] as bool? ?? false;
    _currency = prefs[PrefKeys.currency] as String? ?? CurrencyType.values[0].name.toString().toUpperCase();
  }

  void toggleDarkMode(bool boolean) async {
    _darkMode = boolean;
    await WorkerBee.addOrUpdateItem(PrefKeys.darkMode, _darkMode);
    notifyListeners();
  }

  void setCurrency(String currency) async {
    _currency = currency;
    await WorkerBee.addOrUpdateItem(PrefKeys.currency, currency);
    notifyListeners();
  }
}

class PrefKeys {
  static final String darkMode = 'darkMode';
  static final String currency = 'currency';
}
