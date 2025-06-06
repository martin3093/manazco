// lib/theme/app_themes.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manazco/bloc/theme/colors.dart';

class AppThemes {
  // Tema Claro
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme para tema claro
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightSecondary,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        error: AppColors.lightError,
        onPrimary: AppColors.lightOnPrimary,
        onSecondary: AppColors.lightOnSecondary,
        onBackground: AppColors.lightOnBackground,
        onSurface: AppColors.lightOnSurface,
        onError: AppColors.lightOnError,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.lightOnPrimary,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.lightBackground,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightError),
        ),
        labelStyle: GoogleFonts.roboto(color: AppColors.grey600, fontSize: 16),
        hintStyle: GoogleFonts.roboto(color: AppColors.grey500, fontSize: 16),
      ),

      // Text Theme
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        displayLarge: GoogleFonts.roboto(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnBackground,
        ),
        displayMedium: GoogleFonts.roboto(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnBackground,
        ),
        displaySmall: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnBackground,
        ),
        headlineLarge: GoogleFonts.roboto(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.lightOnBackground,
        ),
        headlineMedium: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.lightOnBackground,
        ),
        headlineSmall: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.lightOnBackground,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.lightOnBackground,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.lightOnBackground,
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.lightOnBackground,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.grey700, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.grey300,
        thickness: 1,
      ),
    );
  }

  // Tema Oscuro
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme para tema oscuro
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        error: AppColors.darkError,
        onPrimary: AppColors.darkOnPrimary,
        onSecondary: AppColors.darkOnSecondary,
        onBackground: AppColors.darkOnBackground,
        onSurface: AppColors.darkOnSurface,
        onError: AppColors.darkOnError,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.darkOnSurface,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.darkSurface,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey800,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkError),
        ),
        labelStyle: GoogleFonts.roboto(color: AppColors.grey400, fontSize: 16),
        hintStyle: GoogleFonts.roboto(color: AppColors.grey500, fontSize: 16),
      ),

      // Text Theme
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        displayLarge: GoogleFonts.roboto(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.darkOnBackground,
        ),
        displayMedium: GoogleFonts.roboto(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.darkOnBackground,
        ),
        displaySmall: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.darkOnBackground,
        ),
        headlineLarge: GoogleFonts.roboto(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.darkOnBackground,
        ),
        headlineMedium: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkOnBackground,
        ),
        headlineSmall: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkOnBackground,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.darkOnBackground,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.darkOnBackground,
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.darkOnBackground,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.grey300, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.grey600,
        thickness: 1,
      ),
    );
  }
}
