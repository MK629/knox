import 'package:flutter/material.dart';
import 'package:knox/app/components/record_input_form.dart';
import 'package:knox/app/configs/app_theme.dart';
import 'package:knox/app/contexts/preferences.dart';
import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/finance_record.dart';
import 'package:knox/db/functions/finance_record_keeper.dart';
import 'package:knox/utils/knox_date_util.dart';
import 'package:provider/provider.dart';

class BudgetTracker extends StatefulWidget {
  final bool monthly;
  const BudgetTracker({super.key, required this.monthly});

  @override
  State<BudgetTracker> createState() => _BudgetTrackerState();
}

class _BudgetTrackerState extends State<BudgetTracker> {
  bool incomeSel = true;
  late Future<List<FinanceRecord>> records;

  @override
  void initState() {
    super.initState();
    records = widget.monthly ? FinanceRecordKeeper.selectThisMonthRecordsDESC() : FinanceRecordKeeper.selectAllRecordsDESC();
  }

  void refetch() {
    setState(() {
      records = widget.monthly ? FinanceRecordKeeper.selectThisMonthRecordsDESC() : FinanceRecordKeeper.selectAllRecordsDESC();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.read<Preferences>();
    String currentCurrency = prefs.currency;

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            widget.monthly
                ? "Finances for ${TimeHelper.monthNames[TimeHelper.todayDate.month]}, ${TimeHelper.todayDate.year}"
                : "Finances so far",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: records,
              builder: (context, snapshot) {
                List<FinanceRecord> items = snapshot.hasData ? snapshot.data as List<FinanceRecord> : [];

                double totalSum = 0;

                for (FinanceRecord record in items) {
                  if (record.type == RecordType.income) {
                    totalSum += record.amount;
                  } else if (record.type == RecordType.expense) {
                    totalSum -= record.amount;
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CashFlowCard(totalSum: totalSum, currency: currentCurrency,), //CASHFLOW CARD
                    SizedBox(height: 4,),
                    //MAIN CARD
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
                                    } else if (index == 1) {
                                      setState(() {
                                        incomeSel = false;
                                      });
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
                                child: scrollingCardPocketDisplay(
                                  items.where((element) => incomeSel ? element.type == RecordType.income : element.type == RecordType.expense).toList(),
                                  context,
                                  currentCurrency,
                                  refetch
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
                                    isScrollControlled: false,
                                    context: context,
                                    builder: (context) {
                                      return RecordInputForm();
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//Cashflow card
class CashFlowCard extends StatelessWidget {
  final double totalSum;
  final String currency;

  const CashFlowCard({super.key, required this.totalSum, required this.currency});

  @override
  Widget build(BuildContext context) {
    Color textColor = totalSum >= 0 ? greenColor : redColor;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            cardLabelText("Cash Flow", Icons.payments_outlined, context),
            const SizedBox(height: 10),
            Text(
              totalSum >= 0 ? "+$totalSum $currency" : "$totalSum $currency",
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Card label text formatted with icon
Widget cardLabelText(String label, IconData labelIcon, BuildContext context) {
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      style: Theme.of(context).textTheme.labelLarge,
      children: [
        TextSpan(text: label),
        WidgetSpan(child: SizedBox(width: 4)),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Icon(
            labelIcon,
            color: Theme.of(context).textTheme.labelLarge?.color,
          ),
        ),
      ],
    ),
  );
}

//Needed cuz of toggle button colors get wrong when selected with cardLabelText
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

//Scrolling card pocket display
Widget scrollingCardPocketDisplay(List<FinanceRecord> records, BuildContext context, String currency, VoidCallback refetchCallback) {
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
                  Text("Created: ${KnoxDateUtil.noMilliseconds(record.crtTime)}", style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  Text("Updated: ${KnoxDateUtil.noMilliseconds(record.updTime)}", style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
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
                    return RecordInputForm(updatingFinanceRecord: record,);
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
                FinanceRecordKeeper.deleteRecord(record);
                refetchCallback();
              },
            ),
          ],
        ),
      );
    },
  );
}
