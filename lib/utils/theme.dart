import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF2D5016);
  static const Color accentGreen = Color(0xFF7CB342);
  static const Color leafGreen = Color(0xFF558B2F);
  static const Color sunYellow = Color(0xFFFFC107);
  static const Color frostBlue = Color(0xFF81D4FA);
  static const Color soilBrown = Color(0xFF795548);
  static const Color bgCream = Color(0xFFF5F5DC);

  static ThemeData light() {
    final base = ThemeData.light();
    final scheme = ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
    );
    // Bumped up across the board for older eyes. Body 16 (was 14),
    // headings 20–22 (was 16). One step larger than Material defaults.
    final textTheme = base.textTheme.copyWith(
      headlineSmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
      titleMedium: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      titleSmall: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyLarge: const TextStyle(fontSize: 17, height: 1.5, color: ink),
      bodyMedium: const TextStyle(fontSize: 16, height: 1.5, color: ink),
      bodySmall: TextStyle(
        fontSize: 14,
        height: 1.4,
        color: Colors.grey.shade700,
      ),
      labelLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFFAFAF3),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 26),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFE6E6DC)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding:
            EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        minVerticalPadding: 12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size(0, 52),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size(0, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        unselectedLabelStyle:
            TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 26),
      ),
      dividerTheme: const DividerThemeData(
        space: 1,
        thickness: 1,
        color: Color(0xFFE6E6DC),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryGreen,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: primaryGreen,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  /// Used as the default body color so card text stays readable on the
  /// cream background. Slightly less harsh than pure black.
  static const Color ink = Color(0xFF1F2A18);
}
