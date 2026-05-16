import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knox/app/configs/app_theme.dart';
import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/finance_record.dart';
import 'package:knox/db/functions/finance_record_keeper.dart';

//TODO: Make this dynamic for editing forms
class RecordInputForm extends StatefulWidget {
  final FinanceRecord? updatingFinanceRecord;

  /// If this is used for insertions, leave [updatingRecord] as null.
  const RecordInputForm({super.key, this.updatingFinanceRecord});

  @override
  State<RecordInputForm> createState() => _RecordInputFormState();
}

class _RecordInputFormState extends State<RecordInputForm> {
  late FinanceRecord? updatingFinanceRecord;
  late bool updating;
  late String initialTagValue;
  late String initialAmountValue;
  late RecordType recordType;
  late TextEditingController tagController;
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();

    updatingFinanceRecord = widget.updatingFinanceRecord;
    if(updatingFinanceRecord == null){
      //Init states for an insert-ready form
      updating = false;
      initialTagValue = "";
      initialAmountValue = "";
      recordType = RecordType.income;
    }
    else{
      //Init states for an update-ready form
      updating = true;
      initialTagValue = updatingFinanceRecord!.tag;
      initialAmountValue = updatingFinanceRecord!.amount.toString();
      recordType = updatingFinanceRecord!.type ;
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

                  updatingFinanceRecord!.updateTag(tagInputStr);
                  updatingFinanceRecord!.updateAmount(double.tryParse(amountInputStr) as double);
                  updatingFinanceRecord!.updateType(recordType);

                  await FinanceRecordKeeper.updateRecord(updatingFinanceRecord as FinanceRecord);

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

                  FinanceRecord insertReadyFinanceRecord = FinanceRecord.toInsertObject(
                    recordType,
                    tagInputStr,
                    DateTime.now(),
                    double.tryParse(amountInputStr) as double
                  );

                  await FinanceRecordKeeper.insertNewRecord(insertReadyFinanceRecord);

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
