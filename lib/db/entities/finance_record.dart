import 'package:knox/db/constants.dart';

///Nothing much. Just an entity for the [records] table.
class FinanceRecord {
  int? id;
  late RecordType type;
  late String tag;
  late DateTime crtTime;
  late DateTime updTime;
  late double amount;
  late bool enforced;

  FinanceRecord._({this.id, required this.type, required this.tag, required this.crtTime, required this.updTime, required this.amount, required this.enforced});

  factory FinanceRecord.toInsertObject(RecordType type, String tag, double amount, bool enforced){
    return FinanceRecord._(
      type: type, 
      tag: tag, 
      crtTime: DateTime.now(),
      updTime: DateTime.now(),
      amount: amount,
      enforced: enforced
    );
  }

  factory FinanceRecord.fromMap(Map<String, Object?> mapFromDb){
    return FinanceRecord._(
      id: mapFromDb["id"] as int,
      type: RecordType.values.byName(mapFromDb["type"] as String),
      tag: mapFromDb["tag"] as String,
      crtTime: DateTime.parse(mapFromDb["crt_time"] as String),
      updTime: DateTime.parse(mapFromDb["upd_time"] as String),
      amount: mapFromDb["amount"] as double,
      enforced: mapFromDb["enforced"] as int == 1 ? true : false
    );
  }

  Map<String, Object?> toMap(){
    return {
      "id" : id,
      "type" : type.name,
      "tag" : tag,
      "crt_time" : crtTime.toString(),
      "upd_time" : updTime.toString(),
      "amount" : amount,
      "enforced" : enforced ? 1 : 0
    };
  }

  ///[id] is excluded for insertions.
  Map<String, Object?> toInsertMap(){
    return {
      "type" : type.name,
      "tag" : tag,
      "crt_time" : crtTime.toString(),
      "upd_time" : updTime.toString(),
      "amount" : amount,
      "enforced" : enforced ? 1 : 0
    };
  }

  void updateTag(String newTag){
    tag = newTag;
    updTime = DateTime.now();
  }

  void updateAmount(double newAmount){
    amount = newAmount;
    updTime = DateTime.now();
  }
}