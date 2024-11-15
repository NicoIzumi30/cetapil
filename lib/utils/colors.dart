import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF054F7B);
  static const Color lightSecondary = Color(0xFFFFFFFF);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFB00020);

  // // Dark Theme Colors
  // static const Color darkPrimary = Color(0xffDB4A2B);
  // static const Color darkSecondary = Color(0xFF1565C0);
  // static const Color darkBackground = Color(0xFF121212);
  // static const Color darkSurface = Color(0xFF1E1E1E);
  // static const Color darkError = Color(0xFFCF6679);

  // Common Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  static const Color white = Color(0xFFFFFFFF);
}

class AppTextStyle{
  static TextStyle titlePage = GoogleFonts.plusJakartaSans(
      fontSize: 18,fontWeight: FontWeight.w700,color: Color(0xFF023B5E)
  );
}

class AppThemes {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
      error: AppColors.lightError,
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.lightPrimary,
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(
          color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black87),
    ),
  );

// static final ThemeData dark = ThemeData(
//   brightness: Brightness.dark,
//   primaryColor: AppColors.darkPrimary,
//   scaffoldBackgroundColor: AppColors.darkBackground,
//   colorScheme: const ColorScheme.dark(
//     primary: AppColors.darkPrimary,
//     secondary: AppColors.darkSecondary,
//     surface: AppColors.darkSurface,
//     background: AppColors.darkBackground,
//     error: AppColors.darkError,
//   ),
//   appBarTheme: const AppBarTheme(
//     color: AppColors.darkPrimary,
//     iconTheme: IconThemeData(color: AppColors.white),
//     titleTextStyle: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
//   ),
//   iconTheme: const IconThemeData(color: Colors.white),
//   textTheme: const TextTheme(
//     bodyLarge: TextStyle(color: Colors.white70),
//     bodyMedium: TextStyle(color: Colors.white70),
//     bodySmall: TextStyle(color: Colors.white70),
//   ),
// );

}