class Queries {
  static final String createRecordTable = '''
    
  ''';

  static final String createConstantIncomeTable = '''
    
  ''';

  static final String createConstantExpenseTable = '''
    
  ''';
}

class TableNames{
  static final String recTbl = "records";
  static final String conInTbl = "constant_incomes";
  static final String conOutTbl = "constant_expenses";
}

enum RecordType{
  income, expense
}

enum UpdateInterval{
  hourly, daily, monthly, yearly
}
