import 'package:flutter/material.dart';

class AmaqColors {
  // Brand Colors extracted from Amaq Telecom Logo
  static const Color primaryNavy = Color(0xFF0B3358);
  static const Color midnightDark = Color(0xFF07182B);
  static const Color midnightSurface = Color(0xFF092036);
  static const Color signalCyan = Color(0xFF38BDF8);
  static const Color skyTower = Color(0xFF94C8E3);
  static const Color cardDark = Color(0xFF0D253F);
  
  // Accents & Functional
  static const Color successEmerald = Color(0xFF10B981);
  static const Color alertCoral = Color(0xFFEF4444);
  static const Color slateText = Color(0xFF94A3B8);
  static const Color white = Colors.white;
}

class AmaqTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AmaqColors.midnightDark,
      primaryColor: AmaqColors.primaryNavy,
      colorScheme: const ColorScheme.dark(
        primary: AmaqColors.signalCyan,
        onPrimary: AmaqColors.midnightDark,
        secondary: AmaqColors.primaryNavy,
        surface: AmaqColors.midnightSurface,
        onSurface: AmaqColors.white,
        background: AmaqColors.midnightDark,
        onBackground: AmaqColors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AmaqColors.primaryNavy,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AmaqColors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: AmaqColors.signalCyan),
      ),
      cardTheme: CardTheme(
        color: AmaqColors.cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AmaqColors.primaryNavy.withOpacity(0.5)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AmaqColors.midnightDark,
        selectedItemColor: AmaqColors.signalCyan,
        unselectedItemColor: AmaqColors.slateText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AmaqColors.signalCyan,
          foregroundColor: AmaqColors.midnightDark,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF051323),
        hintStyle: const TextStyle(color: AmaqColors.slateText, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF132F4C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF132F4C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AmaqColors.signalCyan, width: 1.5),
        ),
      ),
    );
  }
}
