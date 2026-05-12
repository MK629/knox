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
  late Future<List<FinanceRecord>> thisMonthRecords;

  @override
  void initState() {
    super.initState();
    thisMonthRecords = widget.monthly ? FinanceRecordKeeper.selectThisMonthRecords() : FinanceRecordKeeper.selectAllRecords();
  }

  void refetch() {
    setState(() {
      thisMonthRecords = widget.monthly ? FinanceRecordKeeper.selectThisMonthRecords() : FinanceRecordKeeper.selectAllRecords();
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
          FutureBuilder(
            future: thisMonthRecords,
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

              return Expanded(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CashFlowCard(totalSum: totalSum, currency: currentCurrency,),
                        IncomeDisplayCard(incomes: items.where((element) => element.type == RecordType.income).toList(), currency: currentCurrency,refetchCallback: refetch,),
                        ExpenseDisplayCard(expenses: items.where((element) => element.type == RecordType.expense).toList(), currency: currentCurrency, refetchCallback: refetch,),
                      ],
                    ),
                    Positioned(
                      bottom: 4,
                      right: 16,
                      child: FloatingActionButton(
                        child: Icon(Icons.post_add_outlined),
                        onPressed: () async {
                          await showModalBottomSheet(
                            isScrollControlled: true,
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
              );
            },
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

class IncomeDisplayCard extends StatelessWidget {
  final List<FinanceRecord> incomes;
  final String currency;
  final VoidCallback refetchCallback;

  const IncomeDisplayCard({super.key, required this.incomes, required this.currency, required this.refetchCallback});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: greenColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            cardLabelText("Income", Icons.insert_chart_outlined, context),
            SizedBox(height: 12),
            scrollingCardPocketDisplay(incomes, context, currency, refetchCallback)
          ],
        ),
      ),
    );
  }
}

//Expense display card
class ExpenseDisplayCard extends StatelessWidget {
  final List<FinanceRecord> expenses;
    final String currency;
  final VoidCallback refetchCallback;

  const ExpenseDisplayCard({super.key, required this.expenses, required this.currency, required this.refetchCallback});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: redColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            cardLabelText("Expenses", Icons.payment_outlined, context),
            SizedBox(height: 12),
            scrollingCardPocketDisplay(expenses, context, currency, refetchCallback)
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

//Scrolling card pocket display
Widget scrollingCardPocketDisplay(List<FinanceRecord> records, BuildContext context, String currency, VoidCallback refetchCallback) {
  ThemeData theme = Theme.of(context);
  return SizedBox(
    height: 200,
    child: ListView.separated(
      itemCount: records.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final record = records[index];

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).textTheme.labelLarge?.color as Color,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.tag,
                      style: theme.textTheme.titleMedium?.copyWith(
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
                    const SizedBox(height: 6),
                    Text("Created: ${KnoxDateUtil.noMilliseconds(record.crtTime)}", style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    Text("Updated: ${KnoxDateUtil.noMilliseconds(record.updTime)}", style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              //TODO: ADD Edit button and function
              IconButton(
                alignment: Alignment.bottomCenter,
                icon: const Icon(Icons.remove_circle_outline_outlined),
                color: Colors.redAccent,
                style: inputFormButtonStyle(),
                onPressed: () async {
                  await FinanceRecordKeeper.deleteRecord(record);
                  refetchCallback();
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}
