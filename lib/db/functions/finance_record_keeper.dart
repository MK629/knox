import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/finance_record.dart';
import 'package:knox/db/functions/db_accountant.dart';

class FinanceRecordKeeper {
  static Future<List<FinanceRecord>> selectAllRecords() async {
    List<Map<String, Object?>>? financeRecordResult =
        await DbAccountant.getAllFromTable(TableNames.recTbl);

    if (financeRecordResult == null || financeRecordResult.isEmpty) {
      return [];
    }

    List<FinanceRecord> financeRecordList = financeRecordResult.map((mapFromDb) => FinanceRecord.fromMap(mapFromDb)).toList();

    return financeRecordList;
  }

  static Future<List<FinanceRecord>> selectThisMonthRecords() async {
    DateTime today = TimeHelper.todayDate;

    String datePattern;

    if (today.month < 10) {
      datePattern = "${today.year}-0${today.month}-%";
    }
    else{
      datePattern = "${today.year}-${today.month}-%";
    }

    return await _getFinanceRecordsFromDatePattern(datePattern);
  }

  static Future<List<FinanceRecord>> selectSpecificMonthRecords(int year, int month) async {
    if (month > 12) {
      throw Exception("${CommonMessages.invalidFormat} month :$month");
    }

    String datePattern;

    if (month < 10) {
      datePattern = "$year-0$month-%";
    } else {
      datePattern = "$year-$month-%";
    }

    return await _getFinanceRecordsFromDatePattern(datePattern);
  }

  //TODO: Maybe a min and max date fetch here for calendar rendering when user has to select a date for financial record viewing?

  static Future<void> insertNewRecord(FinanceRecord financeRecord) async {
    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await db?.insert(TableNames.recTbl, financeRecord.toInsertMap());
  }

  static Future<void> updateRecord(FinanceRecord financeRecord) async {
    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await db?.update(TableNames.recTbl, financeRecord.toMap(), where: "id = ?", whereArgs: [financeRecord.id]);
  }

  static Future<void> deleteRecord(FinanceRecord financeRecord) async {
    await DbAccountant.deleteFromTable(financeRecord.id, TableNames.recTbl);
  }

  //===============[ Private internal ]===============
  static Future<List<FinanceRecord>> _getFinanceRecordsFromDatePattern(String datePattern) async {
    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    List<Map<String, Object?>>? financeRecordResult = await db?.rawQuery(
      'SELECT * FROM ${TableNames.recTbl} WHERE crt_time LIKE \'$datePattern\';',
    );

    if (financeRecordResult == null || financeRecordResult.isEmpty) {
      return [];
    }

    List<FinanceRecord> financeRecordList = financeRecordResult.map((mapFromDb) => FinanceRecord.fromMap(mapFromDb)).toList();

    return financeRecordList;
  }
}
