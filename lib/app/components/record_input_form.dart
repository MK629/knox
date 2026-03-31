import 'package:flutter/material.dart';

class RecordInputForm extends StatelessWidget {
  const RecordInputForm({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Type"),
          Text("Tag"),
          Text("Amount"),
        ],
      ),
    );
  }
}
