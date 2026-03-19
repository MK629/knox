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
        SizedBox(height: 6),
        _makeCommonSettingsOption("App theme", _themeModeToggleButton(preferences)),
        _makeCommonSettingsOption("App theme", _themeModeToggleButton(preferences)),
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
      backgroundColor: WidgetStatePropertyAll(
        darkMode ? Colors.white : Colors.black,
      ),
    ),
    onPressed: () {
      preferences.toggleDarkMode();
    },
  );
}

Column _makeCommonSettingsOption(String label, Widget trigger) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            trigger
          ],
        ),
      ),
      Divider()
    ]
  );
}
