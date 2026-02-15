import 'package:flutter/material.dart';

class AppColors {
  static const tintLight = Color(0xFF0A7EA4);
  static const tintDark = Color(0xFFFFFFFF);

  static const light = {
    'text': Color(0xFF11181C),
    'background': Color(0xFFFFFFFF),
    'tint': tintLight,
    'icon': Color(0xFF687076),
  };

  static const dark = {
    'text': Color(0xFFECEDEE),
    'background': Color(0xFF151718),
    'tint': tintDark,
    'icon': Color(0xFF9BA1A6),
  };
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: AppColors.light['background'],
    textTheme: const TextTheme(titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: AppColors.dark['background'],
    textTheme: const TextTheme(titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  );
}
