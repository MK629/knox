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
        db.execute(Queries.createConstantIncomeTable);
        db.execute(Queries.createConstantExpenseTable);
      },
      version: 1
    );
  }

  static Future<List<Map<String, Object?>>?> getAllFromTable(String tableName) async {
    checkIfDbNull(_db);
    return await _db?.query(tableName);
  }

  static void deleteFromTable(int id, String tableName) async {
    checkIfDbNull(_db);
    await _db?.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  static void checkIfDbNull(Database? db){
    if(db == null){
      throw Exception("Database not initialized. Please run DbAccountant.initDb() first.");
    }
  }
}