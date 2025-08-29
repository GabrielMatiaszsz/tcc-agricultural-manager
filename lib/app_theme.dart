import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    const primary = Color(0xFF4CAF50); // Green
    const secondary = Color(0xFF8D6E63); // Brown
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        background: const Color(0xFFF5F5F5),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      useMaterial3: true,
    );
  }
}

