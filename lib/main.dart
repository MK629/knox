import 'package:flutter/material.dart';
import 'package:knox/app/root.dart';
import 'package:knox/hive/worker_bee.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await WorkerBee.init();
  Map<dynamic, dynamic> prefs = await WorkerBee.getAllItems();

  runApp(Root(prefs: prefs));
}
