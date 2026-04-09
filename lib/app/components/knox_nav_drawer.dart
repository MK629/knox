import 'package:flutter/material.dart';
import 'package:knox/app/contexts/global_keys.dart';
import 'package:knox/app/contexts/navigation_pointer.dart';
import 'package:knox/app/pages/archive.dart';
import 'package:knox/app/pages/budget_tracker.dart';
import 'package:knox/app/pages/recurrings.dart';
import 'package:knox/app/pages/settings.dart';
import 'package:provider/provider.dart';

class KnoxNavigationDrawer extends StatelessWidget {
  const KnoxNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final navPointer = context.watch<NavigationPointer>();
    int selIndex = navPointer.currentIndex;

    return NavigationDrawer(
      selectedIndex: selIndex,
      children: [
        SizedBox(height: 8,),
        NavigationDrawerDestination(icon: Icon(Icons.calendar_month), label: Text("This Month")),
        SizedBox(height: 8,),
        NavigationDrawerDestination(icon: Icon(Icons.timelapse_outlined), label: Text("All Time")),
        SizedBox(height: 8,),
        NavigationDrawerDestination(icon: Icon(Icons.timer_rounded), label: Text("Recurrings")),
        SizedBox(height: 8,),
        NavigationDrawerDestination(icon: Icon(Icons.book_outlined), label: Text("Archive")),
        SizedBox(height: 8,),
        NavigationDrawerDestination(icon: Icon(Icons.settings_outlined), label: Text("Settings")),
        SizedBox(height: 8,),
      ],
      onDestinationSelected: (value) {
        Scaffold.of(context).closeDrawer();
        knoxNavigationKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context) => buildPage(value)));
        navPointer.setCurrentIndex(value);
      },
    );
  }
}

Widget buildPage(int index) {
  switch (index) {
    case 0:
      return BudgetTracker(monthly: true,);
    case 1:
      return BudgetTracker(monthly: false,);
    case 2:
      return Recurrings();
    case 3:
      return Archive();
    case 4:
      return Settings();
    default:
      throw Exception("Index: $index does not exist.");
  }
}
