// lib/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';


class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // --- Skema Warna Utama ---
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.pinkPrimary,
        secondary: AppColors.pinkAccent,
        surface: AppColors.scaffoldBackground,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
      ),


      // --- Gaya Tipografi Global ---
      textTheme: const TextTheme(
        // Judul Besar (Splash, Login Title)
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: AppColors.pinkDark,
        ),
        // Judul Halaman (Welcome)
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.pinkDark,
          letterSpacing: 0.5,
        ),
        // Subtitle/Caption
        bodySmall: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w400,
        ),
        // Teks Isi Default
        bodyMedium: TextStyle(
          fontSize: 16,
          color: AppColors.textMain,
          fontWeight: FontWeight.normal,
        ),
      ),


      // --- Gaya Tombol Utama (ElevatedButton) ---
      // --- Gaya Tombol Utama (ElevatedButton) ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pinkAccent,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 3,
          shadowColor: AppColors.shadowColor.withOpacity(0.5),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          // 🛠️ PERBAIKAN: Gunakan parameter 'padding', bukan 'contentPadding'
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),


      // --- Gaya Input Field (TextField) ---
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: AppColors.pinkAccent, fontSize: 14),
        filled: true,
        fillColor: AppColors.inputFilled.withOpacity(0.9),
        prefixIconColor: AppColors.pinkAccent,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: const TextStyle(color: AppColors.inputHint, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.pinkAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),


      // --- Gaya Tombol Teks (TextButton) ---
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.pinkDark,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),


      // --- Gaya Snackbar ---
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(color: AppColors.textOnPrimary),
      ),
    );
  }
}
