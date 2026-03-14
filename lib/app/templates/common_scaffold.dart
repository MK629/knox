import 'package:flutter/material.dart';
import 'package:knox/app/components/app_drawer.dart';

class CommonScaffold extends StatelessWidget {
  final Widget widget;
  const CommonScaffold({super.key, required this.widget});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Knox"),
          centerTitle: true
        ),
        body: widget,
        drawer: KnoxNavigationDrawer(),
      ),
    );
  }
}