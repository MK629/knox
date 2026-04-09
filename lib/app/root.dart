import 'package:flutter/material.dart';
import 'package:knox/app/configs/app_theme.dart';
import 'package:knox/app/contexts/navigation_pointer.dart';
import 'package:knox/app/contexts/preferences.dart';
import 'package:knox/app/pages/budget_tracker.dart';
import 'package:knox/app/templates/knox_scaffold.dart';
import 'package:provider/provider.dart';

class Root extends StatelessWidget {
  final Map<dynamic, dynamic> prefs;

  const Root({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Preferences(prefs)),
        ChangeNotifierProvider(create: (_) => NavigationPointer()),
      ],
      child: Builder(
        builder: (context){
          final preferences = context.watch<Preferences>();
          return MaterialApp(
            home: KnoxScaffold(firstPage: BudgetTracker(monthly: true,)),
            themeMode: preferences.darkMode ? ThemeMode.dark : ThemeMode.light,
            darkTheme: darkTheme(),
            theme: lightTheme(),
          );
        },
      ),
    );
  }
}
