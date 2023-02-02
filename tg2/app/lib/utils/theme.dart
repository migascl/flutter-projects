import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Theme file for the app
class AppTheme {
  static final ColorScheme _colorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF001941)).copyWith(
    brightness: Brightness.light,
    primary: Color(0xFF22305E),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF4F597E),
    onPrimaryContainer: Colors.white,
    secondary: Color(0xFF2258A5),
    onSecondary: Colors.white,
    tertiary: Color(0xFF000925),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF151F41),
    onTertiaryContainer: Colors.white,
    error: Color(0xFFE57373),
    onError: Colors.white,
    background: Color(0xFFF5F5F5),
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    surfaceVariant: Color(0xFFE8EAEE),
    onSurfaceVariant: Colors.black,
    outline: Color(0xFFD9DCE4),
  );

  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
      textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme),
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: _colorScheme.background,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _colorScheme.tertiary,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.5, color: _colorScheme.outline),
          borderRadius: BorderRadius.zero,
        ),
      ),
      dividerTheme: DividerThemeData(color: _colorScheme.outline),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: _colorScheme.surface,
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.black.withOpacity(0.25),
      dialogTheme: const DialogTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        elevation: 0,
        splashFactory: NoSplash.splashFactory,
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        elevation: 0,
        splashFactory: NoSplash.splashFactory,
      )),
      chipTheme: ChipThemeData(
        pressElevation: 0,
        selectedColor: _colorScheme.primaryContainer,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
      ),
    );
  }
}
