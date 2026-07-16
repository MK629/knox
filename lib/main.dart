import 'package:flutter/material.dart';
import 'package:knox/app/contexts/preferences.dart';
import 'package:knox/app/root.dart';
import 'package:knox/db/functions/db_accountant.dart';
import 'package:knox/db/functions/life_duty_enforcer.dart';
import 'package:knox/hive/worker_bee.dart';
import 'package:knox/app/configs/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sqflite.devSetDebugModeOn(true);
  await DbAccountant.initDb();

  await WorkerBee.init();
  Map<dynamic, dynamic> prefs = await WorkerBee.getAllItems();

  //runApp(Root(prefs: prefs));
  runApp(FutureBuilder(
    future: LifeDutyEnforcer.enforceDuty(),
    builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          bool darkMode = prefs[PrefKeys.darkMode] as bool? ?? false; //McGuyvering stuff. I know.
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
            darkTheme: darkTheme(),
            theme: lightTheme(),
          );
        }
        else{
          return Root(prefs: prefs);
        }
      },
    )
  );
}
