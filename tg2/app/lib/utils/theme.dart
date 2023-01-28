import 'package:flutter/material.dart';

// Theme file for the app
class AppTheme {
  static ColorScheme colorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2C3965),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF7A839E),
    onPrimaryContainer: Colors.black,
    secondary: Color(0xFF151F41),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF22305E),
    onSecondaryContainer: Colors.white,
    tertiary: Color(0xFF2258A5),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFD7E2FF),
    onTertiaryContainer: Colors.black,
    error: Color(0xFFE57373),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD8),
    onErrorContainer: Colors.black,
    background: Color(0xFFF5F5F5),
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    surfaceVariant: Color(0xFFE8EAEE),
    onSurfaceVariant: Colors.black,
    inverseSurface: Color(0xFF000925),
    onInverseSurface: Colors.white,
    inversePrimary: Color(0xFF4F597E),
  );

  static ThemeData theme = ThemeData(
    colorScheme: colorScheme,
    appBarTheme: AppBarTheme(elevation: 0, backgroundColor: colorScheme.inverseSurface),
    cardTheme: const CardTheme(elevation: 0),
  );
}
