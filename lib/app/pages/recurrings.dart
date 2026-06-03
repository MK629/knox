import 'package:flutter/material.dart';
import 'package:knox/app/components/life_duty_input_form.dart';
import 'package:knox/app/configs/app_theme.dart';
import 'package:knox/app/contexts/preferences.dart';
import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/life_duty.dart';
import 'package:knox/db/functions/life_duty_enforcer.dart';
import 'package:knox/utils/knox_date_util.dart';
import 'package:provider/provider.dart';

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
    lifeDuties = incomeSel ? LifeDutyEnforcer.selectAllDutiesByType(RecordType.income) : LifeDutyEnforcer.selectAllDutiesByType(RecordType.expense);
  }

  void refetch() {
    setState(() {
      lifeDuties = incomeSel ? LifeDutyEnforcer.selectAllDutiesByType(RecordType.income) : LifeDutyEnforcer.selectAllDutiesByType(RecordType.expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.read<Preferences>();
    String currentCurrency = prefs.currency;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 20,
        children: [
          Text("Your constant incomes & expenses", style: Theme.of(context).textTheme.titleLarge,),
          Expanded(
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        future: lifeDuties,
                        builder: (context, snapshot) {
                          List<LifeDuty> items = snapshot.hasData ? snapshot.data as List<LifeDuty> : [];
                          return scrollingCardPocketDisplay(items, context, currentCurrency, refetch);
                        },
                      ),
                    )
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    width: double.infinity,
                    child: IconButton(
                      icon: Icon(Icons.post_add_outlined),
                      style: inputFormButtonStyle(),
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return LifeDutyInputForm();
                          },
                        );

                        refetch();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

Widget scrollingCardPocketDisplay(List<LifeDuty> records, BuildContext context, String currency, VoidCallback refetchCallback) {
  ThemeData theme = Theme.of(context);

  return ListView.separated(
    itemCount: records.length,
    separatorBuilder: (_, _) => const SizedBox(height: 10),
    itemBuilder: (context, index) {
      final record = records[index];

      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: record.type == RecordType.income ? greenColor : redColor,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.tag,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${record.amount}",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: record.type == RecordType.income ? greenColor : redColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    record.updateInterval.name.toUpperCase(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text("Start date: ${KnoxDateUtil.noTime(record.startDate)}", style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  Text("Last implemented: ${KnoxDateUtil.noTime(record.latestUpdate)}", style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
            IconButton(
              alignment: Alignment.bottomCenter,
              icon: const Icon(Icons.edit),
              style: inputFormButtonStyle(),
              onPressed: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return LifeDutyInputForm(updatingLifeduty: record,);
                  },
                );
                refetchCallback();
              },
            ),
            IconButton(
              alignment: Alignment.bottomCenter,
              icon: const Icon(Icons.remove_circle_outline_outlined),
              color: Colors.redAccent,
              style: inputFormButtonStyle(),
              onPressed: () async {
                LifeDutyEnforcer.deleteDuty(record);
                refetchCallback(); //TODO: Implement
              },
            ),
          ],
        ),
      );
    },
  );
}
