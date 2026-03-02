import 'package:knox/db/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbAccountant {
  static late Database? _db;

  static Database? get getDb => _db;

  static void initDb() async {
    String databasesPath = await getDatabasesPath();

    _db = await openDatabase(
      join(databasesPath, 'knox.db'),
      onCreate: (db, version) {
        db.execute(Queries.createRecordTable);
        db.execute(Queries.createLifeDutyTable);
      },
      version: 1
    );
  }

  static Future<List<Map<String, Object?>>?> getAllFromTable(String tableName) async {
    _checkValidTableName(tableName);
    checkIfDbNullOrOpen(_db);
    return await _db?.query(tableName);
  }

  static Future<void> deleteFromTable(int? id, String tableName) async {
    _checkValidTableName(tableName);
    checkIfDbNullOrOpen(_db);
    await _db?.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  static void checkIfDbNullOrOpen(Database? db){
    if(db == null || !db.isOpen){
      throw Exception("Database not initialized. Please run DbAccountant.initDb() first.");
    }
  }

  ///Will remove after development
  static Future<void> cleanDb() async {
    checkIfDbNullOrOpen(_db);
    await _db?.delete(TableNames.recTbl);
    await _db?.delete(TableNames.lifeDutyTbl);
  }

  static void _checkValidTableName(String table){
    if(table != TableNames.lifeDutyTbl || table != TableNames.recTbl){
      throw Exception("Invalid table name. Write either [${TableNames.lifeDutyTbl}] or [${TableNames.recTbl}].");
    }
  }
}