import 'package:flutter/material.dart';

class AppTheme {
  // 🔥 Core colors (from screenshot)
  static const Color black = Color(0xFF000000);
  static const Color darkBg = Color(0xFF0B0B0B);
  static const Color card = Color(0xFF1A1A1A);
  static const Color border = Color(0xFF2A2A2A);

  static const Color primaryOrange = Color(0xFFFF7A1A);
  static const Color mutedText = Color(0xFF9A9A9A);
  static const Color lightText = Color(0xFFE6E6E6);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // 🌑 Backgrounds
      scaffoldBackgroundColor: black,
      canvasColor: black,

      // 🎯 Primary color
      colorScheme: const ColorScheme.dark(
        primary: primaryOrange,
        secondary: primaryOrange,
        background: black,
        surface: card,
        onPrimary: Colors.white,
        onSurface: lightText,
      ),

      // 🧭 AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: primaryOrange),
      ),

      // 🔘 Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryOrange,
          side: const BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 🧾 Cards
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),

      // ✏️ Text
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: lightText),
        bodySmall: TextStyle(color: mutedText),
        titleMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),

      // 📄 Divider
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
      ),

      // 🔍 Search / Inputs
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: card,
        hintStyle: TextStyle(color: mutedText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
      ),

      // 🧩 Icons
      iconTheme: const IconThemeData(
        color: lightText,
      ),
    );
  }
}
