class Queries {
  static final String createRecordTable = '''
    CREATE TABLE IF NOT EXISTS ${TableNames.recTbl} (
      id INTEGER PRIMARY KEY,
      type TEXT NOT NULL,
      tag TEXT NOT NULL,
      crt_time TEXT NOT NULL,
      upd_time TEXT NOT NULL,
      amount DOUBLE NOT NULL,
      enforcement TEXT NOT NULL 
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
  manual, daily, monthly, yearly
}

