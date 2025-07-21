import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFF1993E5);
  static const secondary = Color(0xFFE0F2F7);
  static const accent = Color(0xFF3B82F6);
  static const background = Color(0xFFF8FAFC);
  static const textPrimary = Color(0xFF1E3A8A);
  static const textSecondary = Color(0xFF64748B);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);

  static final data = ThemeData.light().copyWith(
    primaryColor: Color.fromRGBO(25, 147, 229, 1),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
    ).copyWith(primary: primary, surface: background),
    textTheme: GoogleFonts.lexendTextTheme(textTheme),
    scaffoldBackgroundColor: background,
  );

  static final textTheme = ThemeData.light().textTheme.apply(
    bodyColor: textPrimary,
    displayColor: textPrimary,
  );
}
