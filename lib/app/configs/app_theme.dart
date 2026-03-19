import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: lightColor1,
      onPrimary: lightColor2,
      secondary:  lightColor5,
      onSecondary: lightColor1,
      error: lightColor1,
      onError: lightColor1,
      surface: lightColor1,
      onSurface: lightColor5,
    ),
    appBarTheme: AppBarTheme(

    ),
    textTheme: TextTheme(),
    buttonTheme: ButtonThemeData(),
    iconButtonTheme: IconButtonThemeData(),
    drawerTheme: shardDrawerTheme(),
    dividerTheme: sharedDividerTheme(),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    colorScheme: ColorScheme.dark(),
    appBarTheme: AppBarTheme(

    ),
    textTheme: TextTheme(),
    buttonTheme: ButtonThemeData(),
    iconButtonTheme: IconButtonThemeData(),
    drawerTheme: shardDrawerTheme(),
    dividerTheme: sharedDividerTheme(),
  );
}

DrawerThemeData shardDrawerTheme() {
  return DrawerThemeData(width: 200);
}

DividerThemeData sharedDividerTheme() {
  return DividerThemeData(color: Colors.grey, thickness: 0.75);
}

Color lightColor1 = Color(0xFFFCF8F8);
Color lightColor2 = Color(0xFFFBEFEF);
Color lightColor3 = Color(0xFFF9DFDF);
Color lightColor4 = Color(0xFFF5AFAF);
Color lightColor5 =  Color(0xFFAB5757);
