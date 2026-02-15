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
class Lifeduty {
  int? id;
  late String tag;
  late UpdateInterval interval;
  late double amount;

  Lifeduty({this.id, required this.tag, required this.interval, required this.amount});
}