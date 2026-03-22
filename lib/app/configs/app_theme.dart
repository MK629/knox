import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: lightColor1,
      onPrimary: lightColor5,
      secondary:  lightColor5,
      onSecondary: lightColor1,
      error: lightColor5,
      onError: lightColor1,
      surface: lightColor1,
      onSurface: lightColor5,
    ),
    textTheme: sharedTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: lightColor5,
      foregroundColor: lightColor1,
      toolbarHeight: 65,
    ),
    buttonTheme: ButtonThemeData(),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(lightColor5),
        foregroundColor: WidgetStatePropertyAll(lightColor1),
        splashFactory: NoSplash.splashFactory,
      )
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      color: lightColor5,
      selectedColor: lightColor1,
      fillColor: lightColor5,
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderColor: lightColor5,
      selectedBorderColor: lightColor5,
    ),
    drawerTheme: shardDrawerTheme(),
    dividerTheme: DividerThemeData(
      color: lightColor4,
      thickness: 0.75
    )
  );
}

ThemeData darkTheme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: darkColor1,
      onPrimary: darkColor5,
      secondary:  darkColor5,
      onSecondary: darkColor1,
      error: darkColor5,
      onError: darkColor1,
      surface: darkColor1,
      onSurface: darkColor5,
    ),
    textTheme: sharedTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: darkColor1,
      foregroundColor: darkColor5,
      toolbarHeight: 65,
      shape: Border(bottom: BorderSide(color: darkColor5)),
    ),
    buttonTheme: ButtonThemeData(),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(darkColor5),
        foregroundColor: WidgetStatePropertyAll(darkColor1),
        splashFactory: NoSplash.splashFactory,
      )
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      color: darkColor5,
      selectedColor: darkColor1,
      fillColor: darkColor5,
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderColor: darkColor5,
      selectedBorderColor: darkColor5,
    ),
    drawerTheme: shardDrawerTheme(),
    dividerTheme: DividerThemeData(
      color: darkColor5,
      thickness: 0.75
    )
  );
}

DrawerThemeData shardDrawerTheme() {
  return DrawerThemeData(width: 200);
}

TextTheme sharedTextTheme() {
  return TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),

    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),

    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),

    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),

    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),

    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),

    labelSmall: TextStyle(
      fontSize: 12,
    ),
  );
}

//=============[ Light colours ]=============
Color lightColor1 = Color(0xFFFCF8F8);
Color lightColor2 = Color(0xFFFBEFEF);
Color lightColor3 = Color(0xFFF9DFDF);
Color lightColor4 = Color(0xFFF5AFAF);
Color lightColor5 =  Color(0xFFAB5757);

//=============[ Dark colours ]=============
Color darkColor1 = Color(0xFF21243D);
Color darkColor2 = Color(0xFF88E1F2);
Color darkColor3 = Color(0xFFFFD082);
Color darkColor4 = Color(0xFFFF7C7C);
Color darkColor5 = Color(0xFFFCF8F8);
