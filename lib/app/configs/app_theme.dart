import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: lightColor1,
      onPrimary: lightColor2,
      secondary: lightColor2,
      onSecondary: lightColor1,
      error: lightColor2,
      onError: lightColor1,
      surface: lightColor1,
      onSurface: lightColor2,
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
        color: lightColor2,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      labelSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
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
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightColor2,
      foregroundColor: lightColor1
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
      shape: RoundedRectangleBorder(
        side: BorderSide(color: lightColor2, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      labelStyle: TextStyle(
        color: lightColor2,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: TextStyle(
        color: lightColor2,
        fontWeight: FontWeight.w500,
      ),
      focusColor: lightColor2,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: lightColor2,
          width: 1
        )
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: lightColor2,
          width: 1
        )
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: lightColor2,
      selectionColor: lightColor2.withValues(alpha: 0.3),
      selectionHandleColor: lightColor2,
    ),
    drawerTheme: shardDrawerTheme(),
    dividerTheme: DividerThemeData(color: lightColor2, thickness: 0.75),
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
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkColor2,
      foregroundColor: darkColor1
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
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      labelStyle: TextStyle(
        color: darkColor2,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: TextStyle(
        color: darkColor2,
        fontWeight: FontWeight.w500,
      ),
      focusColor: darkColor2,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: darkColor2,
          width: 1
        )
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: darkColor2,
          width: 1
        )
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: darkColor2,
      selectionColor: darkColor2.withValues(alpha: 0.3),
      selectionHandleColor: darkColor2,
    ),
    drawerTheme: shardDrawerTheme(),
    dividerTheme: DividerThemeData(color: darkColor2, thickness: 0.75),
  );
}

//=============[ Light colours ]=============
Color lightColor1 = Color(0xFFFCF8F8);
Color lightColor2 = Color(0xFF2D4263);
Color lightColor3 = Color(0xFFECDBBA);
Color lightColor4 = Color(0xFF191919);

Color redColor = Color(0xFFC84B31);
Color greenColor = Color(0xFF4FA095);


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



//=============[ Reusable style configs ]=============
DrawerThemeData shardDrawerTheme() {
  return DrawerThemeData(width: 200);
}

ButtonStyle inputFormButtonStyle() {
  return ButtonStyle(
    padding: WidgetStatePropertyAll(EdgeInsets.all(14)),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );
}

//Unused yet
ButtonStyle dropDownMenuButtonStyle(){
  return ButtonStyle(
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    backgroundColor: WidgetStateProperty.all(
      Colors.grey.shade900,
    ),
    foregroundColor: WidgetStateProperty.all(
      Colors.white,
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    side: WidgetStateProperty.all(
      BorderSide(
        color: Colors.grey.shade700,
      ),
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
