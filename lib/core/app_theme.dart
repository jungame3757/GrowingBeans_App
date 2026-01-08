import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Kids-friendly color palette (More vibrant but soft)
  static const Color primaryColor = Color(0xFFFFCC33); // Bright Sun Yellow
  static const Color secondaryColor = Color(0xFF4FC3F7); // Light Sky Blue
  static const Color accentColor = Color(0xFFFF8A65); // Warm Coral
  static const Color backgroundColor = Color(0xFFFFFDE7); // Creamy Yellow
  static const Color successColor = Color(0xFF66BB6A); // Fresh Grass Green
  static const Color errorColor = Color(0xFFFF7043); // Soft Red-Orange

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: Colors.white,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.brown[900]!,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w800,
          color: Colors.brown[900],
          fontSize: 32,
        ),
        titleLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
          fontSize: 24,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: Colors.brown[700],
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.brown[900],
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.brown[900],
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(200, 64), // 거대 버튼 규격 적용
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          elevation: 6,
          shadowColor: secondaryColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32), // 더 둥근 모서리
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.brown.withOpacity(0.1),
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
    );
  }

}
