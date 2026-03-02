import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/finance_record.dart';
import 'package:knox/db/functions/db_accountant.dart';

class FinanceRecordKeeper {

  static Future<List<FinanceRecord>> selectAllRecords() async {
    List<Map<String, Object?>>? financeRecordResult = await DbAccountant.getAllFromTable(TableNames.recTbl);

    if(financeRecordResult == null || financeRecordResult.isEmpty){
      return [];
    }

    List<FinanceRecord> financeRecordList = financeRecordResult.map((mapFromDb) => FinanceRecord.fromMap(mapFromDb)).toList();

    return financeRecordList;
  }

  static Future<List<FinanceRecord>> selectThisMonthRecords() async {
    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    DateTime today = TimeHelper.todayDate;

    String datePattern = "${today.year}-${today.month}-%";

    List<Map<String, Object?>>? financeRecordResult = await db?.rawQuery('SELECT * FROM ${TableNames.recTbl} WHERE crt_time LIKE \'$datePattern\';');

    if(financeRecordResult == null || financeRecordResult.isEmpty){
      return [];
    }

    List<FinanceRecord> financeRecordList = financeRecordResult.map((mapFromDb) => FinanceRecord.fromMap(mapFromDb)).toList();

    return financeRecordList;
  }
  
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
}