import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: lightColor1,
      onPrimary: lightColor6,
      secondary: lightColor6,
      onSecondary: lightColor1,
      error: lightColor6,
      onError: lightColor1,
      surface: lightColor1,
      onSurface: lightColor6,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),

      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),

      titleLarge: TextStyle(color: lightColor6, fontSize: 20, fontWeight: FontWeight.w600),

      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),

      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),

      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),

      labelLarge: TextStyle(
        color: lightColor6,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      labelSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightColor6,
      foregroundColor: lightColor1,
      toolbarHeight: 65,
    ),
    buttonTheme: ButtonThemeData(),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(lightColor6),
        foregroundColor: WidgetStatePropertyAll(lightColor1),
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      color: lightColor6,
      selectedColor: lightColor1,
      fillColor: lightColor6,
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderColor: lightColor6,
      selectedBorderColor: lightColor6,
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: lightColor6, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    drawerTheme: shardDrawerTheme(),
    dividerTheme: DividerThemeData(color: lightColor6, thickness: 0.75),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: darkColor1,
      onPrimary: darkColor2,
      secondary: darkColor2,
      onSecondary: darkColor1,
      error: darkColor2,
      onError: darkColor1,
      surface: darkColor1,
      onSurface: darkColor2,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),

      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),

      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),

      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),

      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),

      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),

      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      labelSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
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
      ),
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
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: darkColor2),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    drawerTheme: shardDrawerTheme(),
    dividerTheme: DividerThemeData(color: darkColor2, thickness: 0.75),
  );
}

DrawerThemeData shardDrawerTheme() {
  return DrawerThemeData(width: 200);
}

//=============[ Light colours ]=============
Color lightColor1 = Color(0xFFFCF8F8);
Color lightColor2 = Color(0xFFC84B31);
Color lightColor3 = Color(0xFFECDBBA);
Color lightColor4 = Color(0xFF191919);
Color lightColor5 = Color(0xFF4FA095);
Color lightColor6 = Color(0xFF2D4263);

//=============[ Dark colours ]=============
Color darkColor1 = Color(0xFF191919);
Color darkColor2 = Color(0xFFFCF8F8);

//=============[ Common colours ]=============
Color commonColor1 = Color(0xFF88E1F2);
Color commonColor2 = Color(0xFFFFD082);
Color commonColor3 = Color(0xFFFF7C7C);
Color commonColor4 = Color(0xFFFBEFEF);
Color commonColor5 = Color(0xFFF9DFDF);
Color commonColor6 = Color(0xFFF5AFAF);
