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
        _makeCommonSettingsOption("App theme", _themeModeToggleButton(preferences), context),
      ],
    );
  }
}

Widget _themeModeToggleButton(Preferences preferences) {
  bool darkMode = preferences.darkMode;

  return ToggleButtons(
    isSelected: [!darkMode, darkMode],
    onPressed: (index){
      if(index == 0){
        preferences.toggleDarkMode(false);
      }
      else if(index == 1){
        preferences.toggleDarkMode(true);
      }
    },
    children: [Icon(Icons.light_mode), Icon(Icons.dark_mode)],
  );
}

Column _makeCommonSettingsOption(String label, Widget triggerWidget, BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            triggerWidget
          ],
        ),
      ),
      Divider()
    ]
  );
}
