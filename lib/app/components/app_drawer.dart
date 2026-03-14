import 'package:flutter/material.dart';
import 'package:knox/app/pages/archive.dart';
import 'package:knox/app/pages/home.dart';
import 'package:knox/app/pages/settings.dart';

class KnoxNavigationDrawer extends StatelessWidget {
  const KnoxNavigationDrawer({ super.key });

  @override
  Widget build(BuildContext context){
    return NavigationDrawer(
      selectedIndex: selIndex,
      children: [
        NavigationDrawerDestination(icon: Icon(Icons.house), label: Text("Home")),
        NavigationDrawerDestination(icon: Icon(Icons.book), label: Text("Archive")),
        NavigationDrawerDestination(icon: Icon(Icons.settings), label: Text("Settings")),
      ],
      onDestinationSelected: (value){
        selIndex = value;
        Scaffold.of(context).closeDrawer();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => buildPage(value)));
      },
    );
  }
}

//Don't need context for this. AppDrawer rebuilds on every navigation
int selIndex = 0;

Widget buildPage(int index){
  switch(index) {
    case 0: return Home();
    case 1: return Archive();
    case 2: return Settings();
    default: throw Exception("Index: $index does not exist.");
  }
}