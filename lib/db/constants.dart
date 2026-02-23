class Queries {
  static final String createRecordTable = '''
    CREATE TABLE IF NOT EXISTS ${TableNames.recTbl} (
      id INTEGER PRIMARY KEY,
      type TEXT NOT NULL,
      tag TEXT NOT NULL,
      crt_time TEXT NOT NULL,
      upd_time TEXT NOT NULL,
      amount DOUBLE NOT NULL,
      enforced INTEGER NOT NULL CHECK (enforced IN (0, 1))
    );
  ''';

  static final String createLifeDutyTable = '''
    CREATE TABLE IF NOT EXISTS ${TableNames.lifeDutyTbl} (
      id INTEGER PRIMARY KEY,
      type TEXT NOT NULL,
      tag TEXT NOT NULL,
      update_interval TEXT NOT NULL,
      amount DOUBLE NOT NULL
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

