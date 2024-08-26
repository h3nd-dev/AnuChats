import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey.shade900,
  scaffoldBackgroundColor: Colors.grey.shade900,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade900,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.grey.shade300),
    titleTextStyle: TextStyle(color: Colors.grey.shade300, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey.shade800,
    inversePrimary: Colors.grey.shade300,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.red,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.grey.shade300),
    bodyMedium: TextStyle(color: Colors.grey.shade300),
    displayLarge: TextStyle(color: Colors.grey.shade300),
    displayMedium: TextStyle(color: Colors.grey.shade300),
  ),
  iconTheme: IconThemeData(color: Colors.grey.shade300),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.grey.shade800,
    textTheme: ButtonTextTheme.primary,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade800,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade600),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade500),
    ),
    labelStyle: TextStyle(color: Colors.grey.shade400),
    hintStyle: TextStyle(color: Colors.grey.shade600),
  ),
  cardColor: Colors.grey.shade800,
  dividerColor: Colors.grey.shade700,
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.all(Colors.grey.shade600),
    trackColor: WidgetStateProperty.all(Colors.grey.shade700),
  ),
);

