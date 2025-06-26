import 'package:flutter/material.dart';
class AppThemes{
  AppThemes._();// make it private
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'gg_sans',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.yellow,
    secondaryHeaderColor: Colors.orange,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'gg_sans',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[800],
    primaryColor: Colors.grey[600],
    secondaryHeaderColor: Colors.grey[400],
  );
}