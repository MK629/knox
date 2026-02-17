import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/finance_record.dart';
import 'package:knox/db/functions/db_accountant.dart';

class FinanceRecordKeeper {
  
  static Future<void> insertNew(FinanceRecord financeRecord) async {
    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await db?.insert(TableNames.recTbl, financeRecord.toInsertMap());
  }

  static Future<void> updateExisting(FinanceRecord financeRecord) async {
    final db = DbAccountant.getDb;
    DbAccountant.checkIfDbNullOrOpen(db);

    await db?.update(TableNames.recTbl, financeRecord.toMap(), where: "id = ?", whereArgs: [financeRecord.id]);  
  }
}