import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/life_duty.dart';
import 'package:knox/db/functions/db_accountant.dart';
import 'package:sqflite/sqlite_api.dart';

class LifeDutyEnforcer {
  
  static Future<void> insertNewDuty(LifeDuty lifeDuty) async {

    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await db?.insert(TableNames.lifeDutyTbl, lifeDuty.toInsertMap());
  }

  static Future<void> updateDuty(LifeDuty lifeDuty) async {

    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await db?.update(TableNames.lifeDutyTbl, lifeDuty.toMap(), where: "id = ?", whereArgs: [lifeDuty.id]);
  }

  static Future<void> enforceDuty() async {
    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await _enforceDaily(db);
    await _enforceMonthly(db);
    await _enforceYearly(db);
  }

  //===============[ Private internal ]===============

  static Future<void> _enforceDaily(Database? db) async {
    //search for max date && enforced == true.

    //if null or max != today, proceed

    //if not, increment till today, calc income and expense for each day.
    List<Map<String, Object?>>? lifeDutyResult = await _fetchLifeDutyByInterval(UpdateInterval.daily, db);

    if(lifeDutyResult != null && lifeDutyResult.isNotEmpty){
      List<LifeDuty> lifeDutyList = lifeDutyResult.map((mapFromDb) => LifeDuty.fromMap(mapFromDb)).toList();
    }
  }

  static Future<void> _enforceMonthly(Database? db) async { 
    List<Map<String, Object?>>? lifeDutyResult = await _fetchLifeDutyByInterval(UpdateInterval.monthly, db);

    if(lifeDutyResult != null && lifeDutyResult.isNotEmpty){
      List<LifeDuty> lifeDutyList = lifeDutyResult.map((mapFromDb) => LifeDuty.fromMap(mapFromDb)).toList();
    }
  }

  static Future<void> _enforceYearly(Database? db) async {
    List<Map<String, Object?>>? lifeDutyResult = await _fetchLifeDutyByInterval(UpdateInterval.yearly, db);

    if(lifeDutyResult != null && lifeDutyResult.isNotEmpty){
      List<LifeDuty> lifeDutyList = lifeDutyResult.map((mapFromDb) => LifeDuty.fromMap(mapFromDb)).toList();
    }
  }

  static Future<List<Map<String, Object?>>?> _fetchLifeDutyByInterval(UpdateInterval updateInterval, Database? db) async {
    return await db?.query(TableNames.lifeDutyTbl, where: "update_interval = ?", whereArgs: [updateInterval.name]);
  }
}