import 'package:flutter/material.dart';
import 'package:knox/app/configs/app_theme.dart';
import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/finance_record.dart';
import 'package:knox/db/functions/finance_record_keeper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<FinanceRecord>> thisMonthRecords;

  @override
  void initState() {
    super.initState();
    thisMonthRecords = FinanceRecordKeeper.selectThisMonthRecords();
  }

  void refetch() {
    setState(() {
      thisMonthRecords = FinanceRecordKeeper.selectThisMonthRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "Finances for ${TimeHelper.monthNames[TimeHelper.todayDate.month]}, ${TimeHelper.todayDate.year}",
            style: Theme.of(context).textTheme.titleLarge
          ),
          SizedBox(height: 20),
          FutureBuilder(
            future: thisMonthRecords,
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return CircularProgressIndicator();
              // }

              List<FinanceRecord> items = snapshot.hasData
                  ? snapshot.data as List<FinanceRecord>
                  : [];

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
                        CashFlowCard(totalSum: totalSum),
                        IncomeDisplayCard(incomes: items.where((element) => element.type == RecordType.income).toList()),
                        ExpenseDisplayCard(expenses: items.where((element) => element.type == RecordType.expense).toList()),
                      ],
                    ),
                    Positioned(
                      bottom: 4,
                      right: 16,
                      child: FloatingActionButton(
                        child: Icon(Icons.post_add_outlined),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context){
                              return Text("TextField here");
                            }
                          );
                          refetch();
                        },
                      ),
                    )
                  ]
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
  const CashFlowCard({super.key, required this.totalSum});

  final double totalSum;

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
              totalSum >= 0 ? "+$totalSum" : "-$totalSum",
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

//Income display card
class IncomeDisplayCard extends StatelessWidget {
  final List<FinanceRecord> incomes;

  const IncomeDisplayCard({
    super.key,
    required this.incomes
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: greenColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            cardLabelText("Income", Icons.insert_chart_outlined, context),
            Container(
              height: 200,
            )
          ]
        ),
      ),
    );
  }
}

//Expense display card
class ExpenseDisplayCard extends StatelessWidget {
  final List<FinanceRecord> expenses;

  const ExpenseDisplayCard({
    super.key,
    required this.expenses
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: redColor),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            cardLabelText("Expenses", Icons.payment_outlined, context),
            Container(
              height: 200,
            ),
          ]
        ),
      ),
    );
  }
}

Text cardLabelText(String label, IconData labelIcon, BuildContext context){
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      style: Theme.of(context).textTheme.labelLarge,
      children: [
        TextSpan(text: label),
        WidgetSpan(
          child: SizedBox(width: 4,)
        ),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Icon(
            labelIcon,
            color: Theme.of(context).textTheme.labelLarge?.color,
          )
        )
      ]
    )
  );
}
