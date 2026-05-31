import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knox/app/configs/app_theme.dart';
import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/life_duty.dart';
import 'package:knox/db/functions/life_duty_enforcer.dart';

class LifeDutyInputForm extends StatefulWidget {
  final LifeDuty? updatingLifeduty;

  /// If this is used for insertions, leave [updatingLifeduty] as null.
  const LifeDutyInputForm({super.key, this.updatingLifeduty});

  @override
  State<LifeDutyInputForm> createState() => _LifeDutyInputFormState();
}
class _LifeDutyInputFormState extends State<LifeDutyInputForm> {
  late LifeDuty? updatingLifeduty;
  late bool updating;
  late String initialTagValue;
  late String initialAmountValue;
  late RecordType recordType;
  late UpdateInterval updateInterval;
  late TextEditingController tagController;
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    updatingLifeduty = widget.updatingLifeduty;
    if(updatingLifeduty == null){
      //Init states for an insert-ready form
      updating = false;
      initialTagValue = "";
      initialAmountValue = "";
      recordType = RecordType.income;
      updateInterval = UpdateInterval.daily;
    }
    else{
      //Init states for an update-ready form
      updating = true;
      initialTagValue = updatingLifeduty!.tag;
      initialAmountValue = updatingLifeduty!.amount.toString();
      recordType = updatingLifeduty!.type;
      updateInterval = updatingLifeduty!.updateInterval;
    }

    tagController = TextEditingController(text: initialTagValue);
    amountController = TextEditingController(text: initialAmountValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Container(
            alignment: Alignment.center,
            child: ToggleButtons(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              isSelected: [
                recordType == RecordType.income,
                recordType == RecordType.expense,
              ],
              children: [
                typeToggleButtonItem("Income", Icons.insert_chart_outlined),
                typeToggleButtonItem("Expense", Icons.payment_outlined),
              ],
              onPressed: (index) {
                setState(() {
                  recordType = RecordType.values[index];
                });
              },
            ),
          ),
          updating ?
          Text(updateInterval.name) //Make UI for this
          :
          Container(
            alignment: Alignment.center,
            child: ToggleButtons(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              isSelected: [
                updateInterval == UpdateInterval.daily,
                updateInterval == UpdateInterval.monthly,
                updateInterval == UpdateInterval.yearly,
              ],
              children: [
                typeToggleButtonItem("Daily", Icons.calendar_today_outlined),
                typeToggleButtonItem("Monthly", Icons.calendar_month_outlined),
                typeToggleButtonItem("Yearly", Icons.calendar_view_day_outlined),
              ],
              onPressed: (index) {
                setState(() {
                  updateInterval = UpdateInterval.values[index];
                });
              },
            ),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Tag"),
            controller: tagController,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Amount"),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            controller: amountController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                style: inputFormButtonStyle(),
                icon: Icon(Icons.close_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              updating ?
              IconButton(
                style: inputFormButtonStyle(),
                icon: Icon(Icons.edit_outlined),
                onPressed: () async {
                  final tagInputStr = tagController.text;
                  final amountInputStr = amountController.text;
                  if (tagInputStr.isEmpty || amountInputStr.isEmpty) {
                    return;
                  }

                  updatingLifeduty!.updateType(recordType);
                  updatingLifeduty!.updateTag(tagInputStr);
                  updatingLifeduty!.updateUpdateInterval(updateInterval);
                  updatingLifeduty!.updateAmount(double.tryParse(amountInputStr) as double);


                  await LifeDutyEnforcer.updateDuty(updatingLifeduty as LifeDuty);

                  if(context.mounted){
                    Navigator.pop(context);
                  }
                },
              )
              :
              IconButton(
                style: inputFormButtonStyle(),
                icon: Icon(Icons.post_add_outlined),
                onPressed: () async {
                  final tagInputStr = tagController.text;
                  final amountInputStr = amountController.text;
                  if (tagInputStr.isEmpty || amountInputStr.isEmpty) {
                    return;
                  }

                  // LifeDuty insertReadyLifeDuty = LifeDuty.toInsertObject(
                  //   tagInputStr,
                  //   recordType,
                  //   updateInterval, double.tryParse(amountInputStr) as double,
                  // );

                  //Complier complains if I don't do this. Will investigate later.
                  if(context.mounted){
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget typeToggleButtonItem(String label, IconData labelIcon) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text.rich(
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.w600),
      TextSpan(
        children: [
          TextSpan(text: label),
          WidgetSpan(child: SizedBox(width: 4)),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(labelIcon),
          ),
        ],
      ),
    ),
  );
}
