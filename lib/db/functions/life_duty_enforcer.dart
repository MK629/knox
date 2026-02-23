import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/life_duty.dart';
import 'package:knox/db/functions/db_accountant.dart';
import 'package:sqflite/sqlite_api.dart';

class LifeDutyEnforcer {
  
  static Future<void> insertNewDuty(LifeDuty lifeDuty, String table) async {
    _checkValidTableName(table);

    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await db?.insert(table, lifeDuty.toInsertMap());
  }

  static Future<void> updateDuty(LifeDuty lifeDuty, String table) async {
    _checkValidTableName(table);

    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await db?.update(table, lifeDuty.toMap(), where: "id = ?", whereArgs: [lifeDuty.id]);
  }

  static Future<void> enforceDuty() async {
    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await _enforceDaily(db);
    await _enforceMonthly(db);
    await _enforceYearly(db);
  }

  static void _checkValidTableName(String table){
    if(table != TableNames.conInTbl || table != TableNames.conOutTbl){
      throw Exception("Invalid table name. Write either [${TableNames.conInTbl}] or [${TableNames.conOutTbl}].");
    }
  }

  //===============[ Private internal ]===============

  static Future<void> _enforceDaily(Database? db) async {
    _increment(UpdateInterval.daily, db);
    _decrement(UpdateInterval.daily, db);
  }

  static Future<void> _enforceMonthly(Database? db) async { 
    _increment(UpdateInterval.monthly, db);
    _decrement(UpdateInterval.monthly, db);
  }

  static Future<void> _enforceYearly(Database? db) async {
    _increment(UpdateInterval.yearly, db);
    _decrement(UpdateInterval.yearly, db);
  }

  static Future<void> _increment(UpdateInterval updateInterval, Database? db) async {
    List<Map<String, Object?>>? lifeDutyResult = await db?.query(TableNames.conInTbl, where: "update_interval = ?", whereArgs: [updateInterval.name]);

    if(lifeDutyResult == null || lifeDutyResult.isEmpty){
      return;
    }

    List<LifeDuty> lifeDutyList = lifeDutyResult.map((map) => LifeDuty.fromMap(map)).toList();

    switch(updateInterval){
      case UpdateInterval.daily:
      case UpdateInterval.monthly:
      case UpdateInterval.yearly:
    }
  }

  static Future<void> _decrement(UpdateInterval updateInterval, Database? db) async {
    List<Map<String, Object?>>? lifeDutyResult = await db?.query(TableNames.conOutTbl, where: "update_interval = ?", whereArgs: [updateInterval.name]);

    if(lifeDutyResult == null || lifeDutyResult.isEmpty){
      return;
    }

    List<LifeDuty> lifeDutyList = lifeDutyResult.map((map) => LifeDuty.fromMap(map)).toList();

    switch(updateInterval){
      case UpdateInterval.daily:
      case UpdateInterval.monthly:
      case UpdateInterval.yearly:
    }
  }

  
}