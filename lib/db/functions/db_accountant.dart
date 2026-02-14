import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbAccountant {
  static late Database db;

  static void initDb() async {
    String databasesPath = await getDatabasesPath();
    db = await openDatabase(join(databasesPath, 'knox.db'));
  }
}