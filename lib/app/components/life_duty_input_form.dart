import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knox/app/configs/app_theme.dart';
import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/life_duty.dart';
import 'package:knox/db/functions/life_duty_enforcer.dart';
import 'package:knox/utils/knox_date_util.dart';

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
  late DateTime startDate;
  late TextEditingController tagController;
  late TextEditingController amountController;
  late TextEditingController startDateTextController;

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
      startDate = DateUtils.dateOnly(DateTime.now());
    }
    else{
      //Init states for an update-ready form
      updating = true;
      initialTagValue = updatingLifeduty!.tag;
      initialAmountValue = updatingLifeduty!.amount.toString();
      recordType = updatingLifeduty!.type;
      updateInterval = updatingLifeduty!.updateInterval;
      startDate = DateUtils.dateOnly(updatingLifeduty!.startDate);
    }

    tagController = TextEditingController(text: initialTagValue);
    amountController = TextEditingController(text: initialAmountValue);
    startDateTextController = TextEditingController(text: KnoxDateUtil.noTime(startDate));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
          updating ?
          Text(KnoxDateUtil.noTime(startDate))
          :
          InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: startDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (pickedDate != null) {
                setState(() {
                  startDate = DateUtils.dateOnly(pickedDate);
                });
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 12),
                  Text(
                    KnoxDateUtil.noTime(startDate),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
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

                  LifeDuty insertReadyLifeDuty = LifeDuty.toInsertObject(
                    tagInputStr,
                    recordType,
                    updateInterval,
                    double.tryParse(amountInputStr) as double,
                    startDate
                  );

                  await LifeDutyEnforcer.insertNewDuty(insertReadyLifeDuty);

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
