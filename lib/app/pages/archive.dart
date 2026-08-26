import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knox/app/components/record_input_form.dart';
import 'package:knox/app/configs/app_theme.dart';
import 'package:knox/app/contexts/preferences.dart';
import 'package:knox/db/constants.dart';
import 'package:knox/db/entities/finance_record.dart';
import 'package:knox/db/functions/finance_record_keeper.dart';
import 'package:knox/utils/knox_date_util.dart';
import 'package:provider/provider.dart';

class Archive extends StatefulWidget {
  const Archive({super.key});

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  bool incomeSel = true;
  late int? month;
  late int? year;
  late TextEditingController yearController;
  Future<List<FinanceRecord>>? records;

  @override
  void initState() {
    super.initState();
    month = null;
    year = null;
    yearController = TextEditingController();
  }

  void gofetch() {
    if (month != null && year != null) {
      setState(() {
        records = FinanceRecordKeeper.selectSpecificMonthRecords(
          year as int,
          month as int,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.read<Preferences>();
    String currentCurrency = prefs.currency;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  DropdownMenu(
                    label: Text("Month"),
                    dropdownMenuEntries: [
                      for (int i = 1; i < TimeHelper.monthNames.length; i++)
                        DropdownMenuEntry(
                          value: i,
                          label: TimeHelper.monthNames[i],
                        ),
                    ],
                    onSelected: (value) => {month = value},
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    menuStyle: MenuStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Year",
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 17,
                          horizontal: 12,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      controller: yearController,
                    ),
                  ),
                  SizedBox(width: 12),
                  IconButton(
                    style: ButtonStyle(
                      iconSize: WidgetStatePropertyAll(39),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    icon: Icon(Icons.search_outlined),
                    onPressed: () {
                      year = int.tryParse(yearController.text);
                      gofetch();
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: records,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "No data",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CashFlowCard(
                      totalSum: totalSum,
                      currency: currentCurrency,
                    ), //CASHFLOW CARD
                    SizedBox(height: 4),
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
                                    minWidth:
                                        buttonWidth -
                                        1.5, //3 pixels overflowed. Manually subtracted 1.5 for each button. Burmese style!
                                    maxWidth:
                                        buttonWidth -
                                        1.5, //3 pixels overflowed. Manually subtracted 1.5 for each button. Burmese style!
                                    minHeight: 48,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
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
                                    iconSpanText(
                                      "Incomes",
                                      Icons.insert_chart_outlined,
                                    ),
                                    iconSpanText(
                                      "Expenses",
                                      Icons.payment_outlined,
                                    ),
                                  ],
                                );
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: scrollingCardPocketDisplay(
                                  items
                                      .where(
                                        (element) => incomeSel
                                            ? element.type == RecordType.income
                                            : element.type ==
                                                  RecordType.expense,
                                      )
                                      .toList(),
                                  context,
                                  currentCurrency,
                                  gofetch,
                                ),
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

class CashFlowCard extends StatelessWidget {
  final double totalSum;
  final String currency;

  const CashFlowCard({
    super.key,
    required this.totalSum,
    required this.currency,
  });

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

Widget iconSpanText(String text, IconData icon) {
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      children: [
        TextSpan(text: text),
        WidgetSpan(child: SizedBox(width: 4)),
        WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(icon)),
      ],
    ),
  );
}

Widget scrollingCardPocketDisplay(
  List<FinanceRecord> records,
  BuildContext context,
  String currency,
  VoidCallback refetchCallback,
) {
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
                      color: record.type == RecordType.income
                          ? greenColor
                          : redColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Created: ${KnoxDateUtil.noMilliseconds(record.crtTime)}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Updated: ${KnoxDateUtil.noMilliseconds(record.updTime)}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
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
                    return RecordInputForm(updatingFinanceRecord: record);
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
