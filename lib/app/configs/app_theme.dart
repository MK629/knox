import 'package:flutter/material.dart';

ThemeData lightTheme(){
  return ThemeData(
    colorScheme: ColorScheme.light(),
    dividerTheme: DividerThemeData(
      color: Colors.grey,
      thickness: 0.75
    ),
  );
}

ThemeData darkTheme(){
  return ThemeData(
    colorScheme: ColorScheme.dark(),
    dividerTheme: DividerThemeData(
      color: Colors.grey,
      thickness: 0.75
    ),
  );
}
