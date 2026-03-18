import 'package:flutter/material.dart';

ThemeData lightTheme(){
  return ThemeData(
    colorScheme: ColorScheme.light(),
    appBarTheme: AppBarTheme(

    ),
    textTheme: TextTheme(

    ),
    buttonTheme: ButtonThemeData(

    ),
    iconButtonTheme: IconButtonThemeData(

    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey,
      thickness: 0.75
    ),
  );
}

ThemeData darkTheme(){
  return ThemeData(
    colorScheme: ColorScheme.dark(),
    appBarTheme: AppBarTheme(

    ),
    textTheme: TextTheme(

    ),
    buttonTheme: ButtonThemeData(

    ),
    iconButtonTheme: IconButtonThemeData(

    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey,
      thickness: 0.75
    ),
  );
}
