import 'package:flutter/material.dart';
import 'package:knox/app/templates/common_scaffold.dart';

class Archive extends StatelessWidget {
const Archive({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return CommonScaffold(
      widget: Text("Archive") 
    );
  }
}