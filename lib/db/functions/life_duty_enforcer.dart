import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/life_duty.dart';
import 'package:knox/db/functions/db_accountant.dart';

class LifeDutyEnforcer {
  
  static Future<void> insertNewDuty(LifeDuty lifeDuty, String table) async {
    checkValidTableName(table);

    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await db?.insert(table, lifeDuty.toInsertMap());
  }

  static Future<void> updateDuty(LifeDuty lifeDuty, String table) async {
    checkValidTableName(table);

    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await db?.update(table, lifeDuty.toMap(), where: "id = ?", whereArgs: [lifeDuty.id]);
  }

  static Future<void> enforceDuty() async {
    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    
  }

  static void checkValidTableName(String table){
    if(table != TableNames.conInTbl || table != TableNames.conOutTbl){
      throw Exception("Invalid table name. Write either [${TableNames.conInTbl}] or [${TableNames.conOutTbl}].");
    }
  }
}