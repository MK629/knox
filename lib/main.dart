import 'package:flutter/material.dart';
import 'package:knox/app/root.dart';
import 'package:knox/db/functions/db_accountant.dart';
import 'package:knox/hive/worker_bee.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sqflite.devSetDebugModeOn(true);
  await DbAccountant.initDb();

  await WorkerBee.init();
  Map<dynamic, dynamic> prefs = await WorkerBee.getAllItems();

  runApp(Root(prefs: prefs));
}
