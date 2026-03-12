import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget page;
  const CommonScaffold({super.key, required this.page});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page,
    );
  }
}