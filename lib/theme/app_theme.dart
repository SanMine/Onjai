import 'package:flutter/material.dart';

/// App theme with calm, premium, and wellness-focused design
/// Aligned with Oonjai logo using soft neutrals and controlled teal accents
class AppTheme {
  // Brand Colors
  static const Color primaryTeal = Color(0xFF1EAD9B);
  static const Color deepTeal = Color(0xFF145A50);
  static const Color mintHighlight = Color(0xFFA8E2D6);
  static const Color lightSageBg = Color(0xFFF6FBFA);
  static const Color surfaceVariant = Color(0xFFEEF5F3);
  static const Color neutralText = Color(0xFF23302D);
  static const Color accentWarmCoral = Color(0xFFFF9B7A);
  static const Color divider = Color(0xFFE5EFEC);

  /// Light theme data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        brightness: Brightness.light,
      ).copyWith(
        primary: primaryTeal,
        onPrimary: Colors.white,
        primaryContainer: mintHighlight,
        onPrimaryContainer: deepTeal,
        secondary: accentWarmCoral,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: neutralText,
        surfaceVariant: surfaceVariant,
        onSurfaceVariant: neutralText,
        background: lightSageBg,
        onBackground: neutralText,
        outline: divider,
        outlineVariant: divider,
      ),
      
      // Scaffold background
      scaffoldBackgroundColor: lightSageBg,
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: deepTeal,
        elevation: 0,
        toolbarHeight: 64,
        iconTheme: IconThemeData(color: deepTeal),
        titleTextStyle: TextStyle(
          color: deepTeal,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: divider, width: 1),
        ),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),
      
      // Text theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: deepTeal,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: deepTeal,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: deepTeal,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: deepTeal,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: neutralText,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: neutralText,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: neutralText,
        ),
        bodyMedium: TextStyle(
          color: neutralText,
        ),
        bodySmall: TextStyle(
          color: Color(0xFF6C7A76),
        ),
        labelLarge: TextStyle(
          color: neutralText,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: neutralText,
        ),
        labelSmall: TextStyle(
          color: Color(0xFF6C7A76),
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryTeal,
          side: const BorderSide(color: primaryTeal),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryTeal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryTeal,
        unselectedItemColor: Color(0xFF6C7A76),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Tab bar theme
      tabBarTheme: const TabBarTheme(
        labelColor: deepTeal,
        unselectedLabelColor: Color(0xFF6C7A76),
        indicatorColor: primaryTeal,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: divider,
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: deepTeal,
        size: 24,
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryTeal,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: deepTeal,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
