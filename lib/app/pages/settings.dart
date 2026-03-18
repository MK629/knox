import 'package:flutter/material.dart';
import 'package:knox/app/contexts/preferences.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = context.read<Preferences>();

    return ListView(
      children: [
        Divider(),
        _makeCommonSettingsTile("App theme", _themeModeToggleButton(preferences)),
        Divider()
      ],
    );
  }
}

Widget _themeModeToggleButton(Preferences preferences) {
  bool darkMode = preferences.darkMode;

  return IconButton(
    icon: Icon(darkMode ? Icons.light_mode : Icons.dark_mode),
    color: darkMode ? Colors.black : Colors.white,
    style: ButtonStyle(
      alignment: Alignment.center,
      backgroundColor: WidgetStatePropertyAll(darkMode ? Colors.white : Colors.black),
    ),
    onPressed: () {
      preferences.toggleDarkMode();
    },
  );
}

ListTile _makeCommonSettingsTile(String label, Widget trigger) {
  return ListTile(
    leading: Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14
      ),
    ),
    trailing: trigger,
  );
}
