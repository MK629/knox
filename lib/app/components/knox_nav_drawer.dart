import 'package:flutter/material.dart';
import 'package:knox/app/contexts/navigation_pointer.dart';
import 'package:knox/app/pages/archive.dart';
import 'package:knox/app/pages/home.dart';
import 'package:knox/app/pages/recurrings.dart';
import 'package:knox/app/pages/settings.dart';
import 'package:provider/provider.dart';

final knoxNavKey = GlobalKey<NavigatorState>();

class KnoxNavigationDrawer extends StatelessWidget {
  const KnoxNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final navPointer = context.watch<NavigationPointer>();
    int selIndex = navPointer.currentIndex;

    return NavigationDrawer(
      selectedIndex: selIndex,
      children: [
        NavigationDrawerDestination(icon: Icon(Icons.house), label: Text("Home")),
        NavigationDrawerDestination(icon: Icon(Icons.repeat), label: Text("Recurrings")),
        NavigationDrawerDestination(icon: Icon(Icons.book), label: Text("Archive")),
        NavigationDrawerDestination(icon: Icon(Icons.settings), label: Text("Settings")),
      ],
      onDestinationSelected: (value) {
        Scaffold.of(context).closeDrawer();
        knoxNavKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context) => buildPage(value)));
        navPointer.setCurrentIndex(value);
      },
    );
  }
}

Widget buildPage(int index) {
  switch (index) {
    case 0:
      return Home();
    case 1:
      return Recurrings();
    case 2:
      return Archive();
    case 3:
      return Settings();
    default:
      throw Exception("Index: $index does not exist.");
  }
}
