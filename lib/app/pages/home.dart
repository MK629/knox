import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "Finances for ${TimeHelper.monthNames[TimeHelper.todayDate.month]}, ${TimeHelper.todayDate.year}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 20,),
          FutureBuilder(
            future: thisMonthRecords,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }

              List<FinanceRecord> items = snapshot.hasData ? snapshot.data as List<FinanceRecord> : [];

              double totalSum = 0;

              for(FinanceRecord record in items){
                if(record.type == RecordType.income){
                  totalSum += record.amount;
                }
                else if(record.type == RecordType.expense){
                  totalSum -= record.amount;
                }
              }

              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              "Cash Flow",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              totalSum >= 0 ? "+$totalSum" : "-$totalSum",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                )
              );
            },
          ),
        ],
      ),
    );
  }
}
