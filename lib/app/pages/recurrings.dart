import 'package:flutter/material.dart';
import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/life_duty.dart';
import 'package:knox/db/functions/life_duty_enforcer.dart';

class Recurrings extends StatefulWidget {
  const Recurrings({super.key});

  @override
  State<Recurrings> createState() => _RecurringsState();
}

class _RecurringsState extends State<Recurrings> {
  bool incomeSel = true;
  late Future<List<LifeDuty>> lifeDuties;

  @override
  void initState() {
    super.initState();
    lifeDuties = incomeSel ? LifeDutyEnforcer.selectAllDutiesByType(RecordType.income) : LifeDutyEnforcer.selectAllDutiesByType(RecordType.income);
  }

  void refetch() {
    setState(() {
      lifeDuties = incomeSel ? LifeDutyEnforcer.selectAllDutiesByType(RecordType.income) : LifeDutyEnforcer.selectAllDutiesByType(RecordType.income);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final buttonWidth = constraints.maxWidth / 2;

                return ToggleButtons(
                  isSelected: [incomeSel, !incomeSel],
                  constraints: BoxConstraints(
                    minWidth: buttonWidth - 1.5, //3 pixels overflowed. Manually subtracted 1.5 for each button. Burmese style!
                    maxWidth: buttonWidth - 1.5, //3 pixels overflowed. Manually subtracted 1.5 for each button. Burmese style!
                    minHeight: 48
                  ),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  onPressed: (index) {
                    if (index == 0) {
                      setState(() {
                        incomeSel = true;
                      });
                      refetch();
                    } else if (index == 1) {
                      setState(() {
                        incomeSel = false;
                      });
                      refetch();
                    }
                  },
                  children: [
                    iconSpanText("Incomes", Icons.insert_chart_outlined),
                    iconSpanText("Expenses", Icons.payment_outlined)
                  ],
                );
              },
            ),
            Expanded(
              child: ListView(

              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget iconSpanText(String text, IconData icon) {
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      children: [
        TextSpan(text: text),
        WidgetSpan(child: SizedBox(width: 4)),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Icon(icon),
        ),
      ],
    ),
  );
}
