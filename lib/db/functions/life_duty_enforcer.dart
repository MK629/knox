import 'package:flutter/material.dart';
import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/finance_record.dart';
import 'package:knox/db/entities/life_duty.dart';
import 'package:knox/db/functions/db_accountant.dart';
import 'package:knox/db/functions/finance_record_keeper.dart';
import 'package:knox/utils/knox_date_util.dart';
import 'package:sqflite/sqlite_api.dart';

class LifeDutyEnforcer {

  static Future<List<LifeDuty>> selectAllDuties() async {
    List<Map<String, Object?>>? lifeDutyResult = await DbAccountant.getAllFromTable(TableNames.lifeDutyTbl);

    if(lifeDutyResult == null || lifeDutyResult.isEmpty){
      return [];
    }

    List<LifeDuty> lifeDutyList = lifeDutyResult.map((mapFromDb) => LifeDuty.fromMap(mapFromDb)).toList();

    return lifeDutyList;
  }
  
  static Future<void> insertNewDuty(LifeDuty lifeDuty) async {
    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    if(DateUtils.isSameDay(lifeDuty.startDate, TimeHelper.todayDate)){
      await FinanceRecordKeeper.insertNewRecord(FinanceRecord.toInsertObject(lifeDuty.type, lifeDuty.tag, TimeHelper.todayDate, lifeDuty.amount));
      lifeDuty.setLatestUpdateDate(TimeHelper.todayDate);
    }

    await db?.insert(TableNames.lifeDutyTbl, lifeDuty.toInsertMap());
  }

  static Future<void> updateDuty(LifeDuty lifeDuty) async {
    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await db?.update(TableNames.lifeDutyTbl, lifeDuty.toMap(), where: "id = ?", whereArgs: [lifeDuty.id]);
  }

  static Future<void> deleteDuty(LifeDuty lifeDuty) async {
    await DbAccountant.deleteFromTable(lifeDuty.id, TableNames.lifeDutyTbl);
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
        //Make-up lost insertions
        if(ld.startDate.isBefore(TimeHelper.todayDate) || DateUtils.isSameDay(ld.startDate, TimeHelper.todayDate)){
          DateTime insertionDate;

          //First time insertion
          if(DateUtils.isSameDay(ld.latestUpdate, TimeHelper.stoneAge)){
            insertionDate = ld.startDate;
          }
          //Continue where last updated
          else{
            insertionDate = ld.latestUpdate.add(Duration(days: 1));
          }

          while(insertionDate.isBefore(TimeHelper.todayDate) || DateUtils.isSameDay(insertionDate, TimeHelper.todayDate)){
            await FinanceRecordKeeper.insertNewRecord(FinanceRecord.toInsertObject(ld.type, ld.tag, insertionDate, ld.amount));
            ld.setLatestUpdateDate(insertionDate);
            insertionDate = insertionDate.add(Duration(days: 1));
          }

          await updateDuty(ld);
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
      if(KnoxDateUtil.isMoreThanOrIsOneMonthDiff(ld.latestUpdate, TimeHelper.todayDate, ld.startDate)){
        //Check if insertion should start.
        if(ld.startDate.isBefore(TimeHelper.todayDate) || DateUtils.isSameDay(ld.startDate, TimeHelper.todayDate)){
          DateTime insertionDate;

          //First time insertion
          if(DateUtils.isSameDay(ld.latestUpdate, TimeHelper.stoneAge)){
            insertionDate = ld.startDate;
          }
          //Continue where last updated
          else{
            insertionDate = KnoxDateUtil.nextMonth(ld.latestUpdate, ld.startDate);
          }

          while(insertionDate.isBefore(TimeHelper.todayDate) || DateUtils.isSameDay(insertionDate, TimeHelper.todayDate)){
            await FinanceRecordKeeper.insertNewRecord(FinanceRecord.toInsertObject(ld.type, ld.tag, insertionDate, ld.amount));
            ld.setLatestUpdateDate(insertionDate);
            insertionDate = KnoxDateUtil.nextMonth(insertionDate, ld.startDate);
          }

          await updateDuty(ld);
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
      if(KnoxDateUtil.isMoreThanOrIsOneYearDiff(ld.latestUpdate, TimeHelper.todayDate, ld.startDate)){
        if(ld.startDate.isBefore(TimeHelper.todayDate) || DateUtils.isSameDay(ld.startDate, TimeHelper.todayDate)){
          DateTime insertionDate;

          //First time insert
          if(DateUtils.isSameDay(ld.latestUpdate, TimeHelper.stoneAge)){
            insertionDate = ld.startDate;
          }
          else{
            insertionDate = KnoxDateUtil.nextYear(ld.latestUpdate, ld.startDate);
          }

          while(insertionDate.isBefore(TimeHelper.todayDate) || DateUtils.isSameDay(insertionDate, TimeHelper.todayDate)){
            await FinanceRecordKeeper.insertNewRecord(FinanceRecord.toInsertObject(ld.type, ld.tag, insertionDate, ld.amount));
            ld.setLatestUpdateDate(insertionDate);
            insertionDate = KnoxDateUtil.nextYear(insertionDate, ld.startDate);
          }

          await updateDuty(ld);
        }
      }
    }
  }

  static Future<List<Map<String, Object?>>?> _fetchLifeDutyByInterval(UpdateInterval updateInterval, Database? db) async {
    return await db?.query(TableNames.lifeDutyTbl, where: "update_interval = ?", whereArgs: [updateInterval.name]);
  }
}