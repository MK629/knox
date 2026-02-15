import 'package:knox/db/constants.dart';

///Nothing much. Just an entity for the [records] table.
class Record {
  int? id;
  late RecordType type;
  late String tag;
  late DateTime crtTime;
  DateTime? updTime;
  late double amount;

  Record({this.id, required this.type, required this.tag, required this.crtTime, this.updTime, required this.amount});
}