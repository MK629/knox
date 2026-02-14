import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbAccountant {
  static late Database _db;

  static Database get getDb => _db;

  static void initDb() async {
    String databasesPath = await getDatabasesPath();

    _db = await openDatabase(
      join(databasesPath, 'knox.db'),
      onCreate: (db, version) {
        
      },
      version: 1
    );
  }
}