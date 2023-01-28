import 'package:flutter/material.dart';

// Theme file for the app
class AppTheme {
  static ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF001941)).copyWith(
    brightness: Brightness.light,
    primary: Color(0xFF22305E),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF4F597E),
    onPrimaryContainer: Colors.white,
    secondary: Color(0xFF2258A5),
    onSecondary: Colors.white,
    //secondaryContainer: Color(0xFF22305E),
    //onSecondaryContainer: Colors.white,
    tertiary: Color(0xFF000925),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF151F41),
    onTertiaryContainer: Colors.white,
    error: Color(0xFFE57373),
    onError: Colors.white,
    //errorContainer: Color(0xFFFFDAD8),
    //onErrorContainer: Colors.black,
    background: Color(0xFFF5F5F5),
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    surfaceVariant: Color(0xFFE8EAEE),
    onSurfaceVariant: Colors.black,
  );

  static ThemeData theme = ThemeData(
    colorScheme: colorScheme,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: colorScheme.tertiary,
    ),
    cardTheme: const CardTheme(elevation: 0),
    splashColor: Colors.transparent,
  );
}
