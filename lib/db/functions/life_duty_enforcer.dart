import 'package:flutter/material.dart';
import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/finance_record.dart';
import 'package:knox/db/entities/life_duty.dart';
import 'package:knox/db/functions/db_accountant.dart';
import 'package:knox/db/functions/finance_record_keeper.dart';
import 'package:knox/utils/knox_date_util.dart';
import 'package:sqflite/sqlite_api.dart';

class LifeDutyEnforcer {
  
  static Future<void> insertNewDuty(LifeDuty lifeDuty) async {

    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    if(DateUtils.isSameDay(lifeDuty.startDate, TimeHelper.todayDate)){
      await FinanceRecordKeeper.insertNew(FinanceRecord.toInsertObject(lifeDuty.type, lifeDuty.tag, TimeHelper.todayDate, lifeDuty.amount));
      lifeDuty.setLatestUpdateDate(TimeHelper.todayDate);
    }

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
    List<Map<String, Object?>>? lifeDutyResult = await _fetchLifeDutyByInterval(UpdateInterval.daily, db);

    if(lifeDutyResult == null || lifeDutyResult.isEmpty){
      return;
    }

    List<LifeDuty> lifeDutyList = lifeDutyResult.map((mapFromDb) => LifeDuty.fromMap(mapFromDb)).toList();

    for(LifeDuty ld in lifeDutyList){
      if(ld.latestUpdate.isBefore(TimeHelper.todayDate)){
        //First-time insertion, if coincidence.
        if(DateUtils.isSameDay(ld.startDate, TimeHelper.todayDate)){
          await FinanceRecordKeeper.insertNew(FinanceRecord.toInsertObject(ld.type, ld.tag, TimeHelper.todayDate, ld.amount));
          ld.setLatestUpdateDate(TimeHelper.todayDate);
          await updateDuty(ld);
        }
        //Make-up lost insertions
        else if(ld.startDate.isBefore(TimeHelper.todayDate)){
          DateTime insertionDate;

          //If no prior update has been done yet. Include first-time insertion.
          if(DateUtils.isSameDay(ld.latestUpdate, DateTime.parse(TimeHelper.lowTimeString))){
            insertionDate = ld.startDate;
          }
          //Continue where last updated
          else{
            insertionDate = ld.latestUpdate.add(Duration(days: 1));
          }

          while(insertionDate.isBefore(TimeHelper.todayDate) || DateUtils.isSameDay(insertionDate, TimeHelper.todayDate)){
            await FinanceRecordKeeper.insertNew(FinanceRecord.toInsertObject(ld.type, ld.tag, insertionDate,ld.amount));
            ld.setLatestUpdateDate(insertionDate);
            await updateDuty(ld);
            insertionDate = insertionDate.add(Duration(days: 1));
          }
        }
      }
    }
  }

  static Future<void> _enforceMonthly(Database? db) async { 
    List<Map<String, Object?>>? lifeDutyResult = await _fetchLifeDutyByInterval(UpdateInterval.monthly, db);

    if(lifeDutyResult == null || lifeDutyResult.isEmpty){
      return;
    }

    List<LifeDuty> lifeDutyList = lifeDutyResult.map((mapFromDb) => LifeDuty.fromMap(mapFromDb)).toList();

    for(LifeDuty ld in lifeDutyList){
      if(KnoxDateUtil.isMoreThanOneMonthDiff(ld.latestUpdate, TimeHelper.todayDate, ld.startDate.day)){
        //First-time insertion, if coincidence.
        if(DateUtils.isSameDay(ld.startDate, TimeHelper.todayDate)){
          await FinanceRecordKeeper.insertNew(FinanceRecord.toInsertObject(ld.type, ld.tag, TimeHelper.todayDate, ld.amount));
          ld.setLatestUpdateDate(TimeHelper.todayDate);
          await updateDuty(ld);
        }
        //Make-up lost insertions
        else if(ld.startDate.isBefore(TimeHelper.todayDate)){
          DateTime insertionDate;

          //If no prior update has been done yet. Include first-time insertion.
          if(DateUtils.isSameDay(ld.latestUpdate, DateTime.parse(TimeHelper.lowTimeString))){
            insertionDate = ld.startDate;
          }
          //Continue where last updated
          else{
            insertionDate = KnoxDateUtil.nextMonth(ld.latestUpdate, ld.startDate.day);
          }

          while(insertionDate.isBefore(TimeHelper.todayDate) || DateUtils.isSameDay(insertionDate, TimeHelper.todayDate)){
            await FinanceRecordKeeper.insertNew(FinanceRecord.toInsertObject(ld.type, ld.tag, insertionDate,ld.amount));
            ld.setLatestUpdateDate(insertionDate);
            await updateDuty(ld);
            insertionDate = KnoxDateUtil.nextMonth(insertionDate, ld.startDate.day);
          }
        }
      }
    }
  }

  static Future<void> _enforceYearly(Database? db) async {
    List<Map<String, Object?>>? lifeDutyResult = await _fetchLifeDutyByInterval(UpdateInterval.yearly, db);

    if(lifeDutyResult == null || lifeDutyResult.isEmpty){
      return;
    }

    List<LifeDuty> lifeDutyList = lifeDutyResult.map((mapFromDb) => LifeDuty.fromMap(mapFromDb)).toList();

    for(LifeDuty ld in lifeDutyList){
      
    }
  }

  static Future<List<Map<String, Object?>>?> _fetchLifeDutyByInterval(UpdateInterval updateInterval, Database? db) async {
    return await db?.query(TableNames.lifeDutyTbl, where: "update_interval = ?", whereArgs: [updateInterval.name]);
  }
}