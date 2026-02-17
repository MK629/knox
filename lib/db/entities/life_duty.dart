import 'package:knox/db/constants.dart';

/// <h2>Life Duty</h2>
/// <br/>
/// <p>
/// Inavoidable.., inevitable... and ultimately implemented regardless of one's delight or disdain...
/// <br/>
/// Such is a life full of many duties and responsibilities.
/// </p>
/// <br/>
/// <h4>What is life, if naught of struggle?</h4>
/// <br/>
/// <h4>What is struggle, if not for life?</h4>
/// <br/>
/// This entity represents recurring, non-negotiable forces:
/// <ul>
/// <li>Income that must arrive</li>
/// <li>Expenses that must be paid</li>
/// </ul>
/// 
/// TL:DR => This is an entity used in [constant_incomes] table and [constant_expenses] table.
class LifeDuty {
  int? id;
  late String tag;
  late UpdateInterval updateInterval;
  late double amount;

  LifeDuty._({this.id, required this.tag, required this.updateInterval, required this.amount});

  factory LifeDuty.toInsertObject(String tag, UpdateInterval updateInterval, double amount){
    return LifeDuty._(
      tag: tag, 
      updateInterval: updateInterval, 
      amount: amount
    );
  }

  factory LifeDuty.fromMap(Map<String, Object?> mapFromDb){
    return LifeDuty._(
      id: mapFromDb["id"] as int,
      tag: mapFromDb["tag"] as String, 
      updateInterval: UpdateInterval.values.byName(mapFromDb["update_interval"] as String), 
      amount: mapFromDb["amount"] as double
    );
  }

  Map<String, Object?> toMap(){
    return {
      "id" : id,
      "tag" : tag,
      "update_interval" : updateInterval.name,
      "amount" : amount
    };
  }

  ///[id] is excluded for insertions.
  Map<String, Object?> toInsertMap(){
    return {
      "tag" : tag,
      "update_interval" : updateInterval.name,
      "amount" : amount
    };
  }

  void updateTag(String newTag){
    tag = newTag;
  }

  void updateAmount(double newAmount){
    amount = newAmount;
  }
}