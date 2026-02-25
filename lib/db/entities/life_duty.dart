import 'package:flutter/material.dart';
import 'package:knox/db/constants.dart';

class LifeDuty {
  int? id;
  late RecordType type;
  late String tag;
  late UpdateInterval updateInterval;
  late double amount;
  late DateTime startDate;
  late DateTime latestUpdate;

  LifeDuty._({this.id, required this.type, required this.tag, required this.updateInterval, required this.amount, required this.startDate, required this.latestUpdate});

  factory LifeDuty.toInsertObject(String tag, RecordType type, UpdateInterval updateInterval, double amount, DateTime startDate, DateTime latestUpdate){
    return LifeDuty._(
      type: type,
      tag: tag, 
      updateInterval: updateInterval, 
      amount: amount,
      startDate: DateUtils.dateOnly(startDate),
      latestUpdate: DateUtils.dateOnly(latestUpdate)
    );
  }

  factory LifeDuty.fromMap(Map<String, Object?> mapFromDb){
    return LifeDuty._(
      id: mapFromDb["id"] as int,
      type: RecordType.values.byName(mapFromDb["type"] as String),
      tag: mapFromDb["tag"] as String, 
      updateInterval: UpdateInterval.values.byName(mapFromDb["update_interval"] as String), 
      amount: mapFromDb["amount"] as double,
      startDate: DateTime.parse(mapFromDb["start_date"] as String),
      latestUpdate: DateTime.parse(mapFromDb["latest_update"] as String)
    );
  }

  Map<String, Object?> toMap(){
    return {
      "id" : id,
      "type" : type.name,
      "tag" : tag,
      "update_interval" : updateInterval.name,
      "amount" : amount,
      "start_date" : startDate.toString(),
      "latest_update" : latestUpdate.toString()
    };
  }

  ///[id] is excluded for insertions.
  Map<String, Object?> toInsertMap(){
    return {
      "type" : type.name,
      "tag" : tag,
      "update_interval" : updateInterval.name,
      "amount" : amount,
      "start_date" : startDate.toString(),
      "latest_update" : latestUpdate.toString()
    };
  }

  void updateTag(String newTag){
    tag = newTag;
  }

  void updateAmount(double newAmount){
    amount = newAmount;
  }

  void setLatestUpdateDate(DateTime newLatestUpdate){
    latestUpdate = DateUtils.dateOnly(newLatestUpdate);
  }
}