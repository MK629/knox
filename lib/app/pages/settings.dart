import 'package:flutter/material.dart';
import 'package:knox/app/contexts/preferences.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = context.read<Preferences>();

    return IconButton(
        icon: Icon(preferences.darkMode ? Icons.dark_mode : Icons.light_mode),
        onPressed: () {
          preferences.toggleDarkMode();
        },
      );
  }
}
