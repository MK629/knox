import 'package:flutter/material.dart';
import 'package:knox/app/pages/home.dart';
import 'package:knox/app/templates/common_scaffold.dart';

class Root extends StatelessWidget {
  const Root({ super.key });

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: CommonScaffold(page: Home()),
    );
  }
}