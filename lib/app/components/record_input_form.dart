import 'package:flutter/material.dart';
import 'package:knox/db/constants.dart';

class RecordInputForm extends StatefulWidget {
  const RecordInputForm({super.key});

  @override
  State<RecordInputForm> createState() => _RecordInputFormState();
}

class _RecordInputFormState extends State<RecordInputForm> {
  late RecordType recordType;
  late TextEditingController tagController;

  @override
  void initState() {
    super.initState();
    recordType = RecordType.income;
    tagController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          Row(
            children: [
              Text("Tag"),
              Expanded(child: TextField()),
            ],
          ),
          Text("Amount"),
          IconButton(
            alignment: Alignment.bottomCenter,
            icon: Icon(Icons.post_add_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

Padding typeToggleButtonItem(String label, IconData labelIcon) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text.rich(
      textAlign: TextAlign.center,
      style: TextStyle(),
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
