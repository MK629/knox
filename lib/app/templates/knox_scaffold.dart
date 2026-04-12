import 'package:flutter/material.dart';
import 'package:knox/app/components/knox_nav_drawer.dart';
import 'package:knox/app/contexts/global_keys.dart';

class KnoxScaffold extends StatelessWidget {
  final Widget firstPage;
  const KnoxScaffold({super.key, required this.firstPage});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu_open_outlined),
                style: ButtonStyle(
                  iconColor: WidgetStatePropertyAll(Theme.of(context).appBarTheme.foregroundColor),
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).appBarTheme.backgroundColor),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }
          ),
          title: Text("KNOX"),
          centerTitle: true,
        ),
        body: Navigator(
          key: knoxNavigationKey,
          onGenerateRoute: (settings){
            return MaterialPageRoute(builder: (context) => firstPage);
          },
        ),
        drawer: KnoxNavigationDrawer(),
      ),
    );
  }
}
