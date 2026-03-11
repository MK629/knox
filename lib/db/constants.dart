import 'package:flutter/material.dart';

class Queries {
  static final String createRecordTable = '''
    CREATE TABLE IF NOT EXISTS ${TableNames.recTbl} (
      id INTEGER PRIMARY KEY,
      type TEXT NOT NULL,
      tag TEXT NOT NULL,
      crt_time TEXT NOT NULL,
      upd_time TEXT NOT NULL,
      amount DOUBLE NOT NULL
    );
  ''';

  static final String createLifeDutyTable = '''
    CREATE TABLE IF NOT EXISTS ${TableNames.lifeDutyTbl} (
      id INTEGER PRIMARY KEY,
      type TEXT NOT NULL,
      tag TEXT NOT NULL,
      update_interval TEXT NOT NULL,
      amount DOUBLE NOT NULL,
      start_date TEXT NOT NULL,
      latest_update TEXT NOT NULL,
    );
  ''';
}

class TableNames{
  static final String recTbl = "records";
  static final String lifeDutyTbl = "life_duties";
}

enum RecordType{
  income, expense
}

enum UpdateInterval{
  daily, monthly, yearly
}

class CommonMessages{
  static final String resultNull = "Result returned null.";
  static final String invalidFormat = "Invalid format.";
}

class TimeHelper{
  static final String _lowTimeString = "0001-01-01 00:00:00.000";
  static DateTime stoneAge = DateTime.parse(_lowTimeString);
  static DateTime todayDate = DateUtils.dateOnly(DateTime.now());
}


