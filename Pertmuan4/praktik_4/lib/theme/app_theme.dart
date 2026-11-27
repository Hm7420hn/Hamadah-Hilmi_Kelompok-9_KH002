import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
      ),
      // Menggunakan latar belakang terang agar sesuai dengan tampilan hasil akhir
      // Jika ingin abu-abu sesuai kode awal, gunakan: const Color(0xFF808080)
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    );
  }
}