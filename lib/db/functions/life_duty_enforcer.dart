import 'package:flutter/material.dart';
import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/finance_record.dart';
import 'package:knox/db/entities/life_duty.dart';
import 'package:knox/db/functions/db_accountant.dart';
import 'package:knox/db/functions/finance_record_keeper.dart';
import 'package:sqflite/sqlite_api.dart';

class LifeDutyEnforcer {
  
  static Future<void> insertNewDuty(LifeDuty lifeDuty) async {

    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await db?.insert(TableNames.lifeDutyTbl, lifeDuty.toInsertMap());

    if(DateUtils.isSameDay(lifeDuty.startDate, DateTime.now())){
      await FinanceRecordKeeper.insertNew(FinanceRecord.toInsertObject(lifeDuty.type, lifeDuty.tag, lifeDuty.amount));
    }
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
    List<Map<String, Object?>>? lifeDutyResult = await _fetchLifeDutyByInterval(UpdateInterval.daily, db);

    if(lifeDutyResult == null || lifeDutyResult.isEmpty){
      return;
    }

    List<LifeDuty> lifeDutyList = lifeDutyResult.map((mapFromDb) => LifeDuty.fromMap(mapFromDb)).toList();

    for(LifeDuty ld in lifeDutyList){
      if(ld.latestUpdate.isBefore(TimeHelper.todayDate)){
        //First-time insertion.
        if(DateUtils.isSameDay(ld.startDate, TimeHelper.todayDate)){
          await FinanceRecordKeeper.insertNew(FinanceRecord.toInsertObject(ld.type, ld.tag, ld.amount));
          //do function to update latestUpdate here
        }
        //Make-up lost insertions
        else if(ld.startDate.isBefore(TimeHelper.todayDate)){
          DateTime insertionStartDate;

          //If no prior update has been done yet
          if(DateUtils.isSameDay(ld.latestUpdate, DateTime.parse(TimeHelper.lowTimeString))){
            insertionStartDate = ld.startDate;
          }
          //Continue where last updated
          else{
            insertionStartDate = ld.latestUpdate;
          }
        }
      }
    }
  }

  static Future<void> _enforceMonthly(Database? db) async { 
    List<Map<String, Object?>>? latestEnforcement = await db?.rawQuery("SELECT MAX(crt_time) AS latest_date FROM ${TableNames.recTbl} WHERE enforcement = '${UpdateInterval.monthly.name}';");

    if(latestEnforcement == null){
      throw Exception(CommonMessages.resultNull);
    }

    List<Map<String, Object?>>? lifeDutyResult = await _fetchLifeDutyByInterval(UpdateInterval.monthly, db);

    if(lifeDutyResult != null && lifeDutyResult.isNotEmpty){
      List<LifeDuty> lifeDutyList = lifeDutyResult.map((mapFromDb) => LifeDuty.fromMap(mapFromDb)).toList();
    }
  }

  static Future<void> _enforceYearly(Database? db) async {
    List<Map<String, Object?>>? latestEnforcement = await db?.rawQuery("SELECT MAX(crt_time) AS latest_date FROM ${TableNames.recTbl} WHERE enforcement = '${UpdateInterval.yearly.name}';");

    if(latestEnforcement == null){
      throw Exception(CommonMessages.resultNull);
    }

    List<Map<String, Object?>>? lifeDutyResult = await _fetchLifeDutyByInterval(UpdateInterval.yearly, db);

    if(lifeDutyResult != null && lifeDutyResult.isNotEmpty){
      List<LifeDuty> lifeDutyList = lifeDutyResult.map((mapFromDb) => LifeDuty.fromMap(mapFromDb)).toList();
    }
  }

  static Future<List<Map<String, Object?>>?> _fetchLifeDutyByInterval(UpdateInterval updateInterval, Database? db) async {
    return await db?.query(TableNames.lifeDutyTbl, where: "update_interval = ?", whereArgs: [updateInterval.name]);
  }
}