// lib/app_colors.dart
import 'package:flutter/material.dart';


class AppColors {
  // --- Pink Pastel Palette ---


  // Warna utama (Main Color)
  static const Color pinkPrimary = Color(0xFFFFC0CB); // Pink cerah untuk tombol
  static const Color pinkAccent = Color(
    0xFFD87093,
  ); // Pink lebih tua untuk ikon/highlight
  static const Color pinkDark = Color(
    0xFFC71585,
  ); // Pink pekat untuk teks utama/kontras


  // Gradasi (Gradient)
  static const Color gradientStart = Color(
    0xFFFFF0F5,
  ); // Lavender Blush (Pink sangat muda)
  static const Color gradientEnd = Color(
    0xFFFFE4E1,
  ); // Misty Rose (Pink pastel hangat)


  // Latar Belakang & Elemen Transparan
  static const Color scaffoldBackground =
      Colors.white; // Putih bersih untuk latar belakang dasar
  static const Color shadowColor = Color(0xFFFFB6C1); // Bayangan pink lembut


  // --- Teks ---


  static const Color textMain = Color(
    0xFF4A4A4A,
  ); // Abu-abu gelap untuk teks isi
  static const Color textSecondary = Color(
    0xFF8B6584,
  ); // Abu-abu pink untuk subtitle/caption
  static const Color textOnPrimary =
      Colors.white; // Warna teks di atas tombol primary


  // --- Input & Form ---


  static const Color inputFilled = Colors.white; // Latar belakang kolom input
  static const Color inputHint = Color(0xFFBDBDBD); // Warna teks hint


  // --- Feedback ---


  static const Color success = Color(0xFF4CAF50); // Hijau untuk snackbar sukses
  static const Color error = Color(
    0xFFE57373,
  ); // Merah untuk error (disesuaikan pastel)
}



