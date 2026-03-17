import 'package:flutter/material.dart';
import 'package:knox/app/components/knox_nav_drawer.dart';
import 'package:knox/app/contexts/global_keys.dart';

class KnoxScaffold extends StatelessWidget {
  final Widget firstPage;
  const KnoxScaffold({super.key, required this.firstPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu_open_outlined),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }
        ),
        title: Text("Knox"),
        centerTitle: true,
      ),
      body: Navigator(
        key: knoxNavigationKey,
        onGenerateRoute: (settings){
          return MaterialPageRoute(builder: (context) => firstPage);
        },
      ),
      drawer: KnoxNavigationDrawer(),
    );
  }
}
