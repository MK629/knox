import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: lightColor1,
      onPrimary: lightColor2,
      secondary:  lightColor2,
      onSecondary: lightColor1,
      error: lightColor2,
      onError: lightColor1,
      surface: lightColor1,
      onSurface: lightColor2,
    ),
    textTheme: sharedTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: lightColor2,
      foregroundColor: lightColor1,
      toolbarHeight: 65,
    ),
    buttonTheme: ButtonThemeData(),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(lightColor2),
        foregroundColor: WidgetStatePropertyAll(lightColor1),
        splashFactory: NoSplash.splashFactory,
      )
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      color: lightColor2,
      selectedColor: lightColor1,
      fillColor: lightColor2,
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderColor: lightColor2,
      selectedBorderColor: lightColor2,
    ),
    cardTheme: CardThemeData(
      color: commonColor4,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: commonColor6,
        ),
        borderRadius: BorderRadius.all(Radius.circular(12))
      )
    ),
    drawerTheme: shardDrawerTheme(),
    dividerTheme: DividerThemeData(
      color: lightColor2,
      thickness: 0.75
    )
  );
}

ThemeData darkTheme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: darkColor1,
      onPrimary: darkColor2,
      secondary:  darkColor2,
      onSecondary: darkColor1,
      error: darkColor2,
      onError: darkColor1,
      surface: darkColor1,
      onSurface: darkColor2,
    ),
    textTheme: sharedTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: darkColor1,
      foregroundColor: darkColor2,
      toolbarHeight: 65,
      shape: Border(bottom: BorderSide(color: darkColor2)),
    ),
    buttonTheme: ButtonThemeData(),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(darkColor2),
        foregroundColor: WidgetStatePropertyAll(darkColor1),
        splashFactory: NoSplash.splashFactory,
      )
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      color: darkColor2,
      selectedColor: darkColor1,
      fillColor: darkColor2,
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderColor: darkColor2,
      selectedBorderColor: darkColor2,
    ),
    cardTheme: CardThemeData(
      color: darkColor1,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: darkColor2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(12))
      )
    ),
    drawerTheme: shardDrawerTheme(),
    dividerTheme: DividerThemeData(
      color: darkColor2,
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
Color lightColor2 =  Color(0xFFAB5757);

//=============[ Dark colours ]=============
Color darkColor1 = Color(0xFF21243D);
Color darkColor2 = Color(0xFFFCF8F8);

//=============[ Common colours ]=============
Color commonColor1 = Color(0xFF88E1F2);
Color commonColor2 = Color(0xFFFFD082);
Color commonColor3 = Color(0xFFFF7C7C);
Color commonColor4  = Color(0xFFFBEFEF);
Color commonColor5 = Color(0xFFF9DFDF);
Color commonColor6 = Color(0xFFF5AFAF);
