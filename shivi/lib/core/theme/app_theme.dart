import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
      headlineSmall: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      bodyMedium: GoogleFonts.poppins(color: AppColors.textDark),
      titleMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.softCream,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.softPurpleDark,
        secondary: AppColors.softBlue,
        surface: Colors.white,
        onPrimary: Colors.white,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.softPurpleDark),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.softPurpleDark,
        unselectedItemColor: Color(0xFFB0A9C0),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.softPurpleDark,
      ),
    );
  }
}
