import 'package:flutter/material.dart';
import 'package:knox/app/templates/common_scaffold.dart';

class Settings extends StatelessWidget {
const Settings({ super.key });

  @override
  Widget build(BuildContext context){
    return CommonScaffold(
      widget: Text("Settings")
    );
  }
}