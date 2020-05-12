import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const nero = Color(0xFF232222),
    stratos = Color(0xFF000240),
    gainsboro = Color(0xFFE1E1E1);

class Style {
  static final primaryDark = nero;
  static final accentDark = gainsboro;
  static final textDark = gainsboro;

  static final primaryLight = Colors.white;
  static final accentLight = stratos;
  static final textLight = Colors.black87;

  static ThemeData get dark => _initTheme(Brightness.dark);
  static ThemeData get light => _initTheme(Brightness.light);

  static ThemeData _initTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: brightness,
      primaryColor: isDark ? primaryDark : primaryLight,
      accentColor: isDark ? accentDark : accentLight,
      scaffoldBackgroundColor: isDark ? primaryDark : primaryLight,
      buttonColor: Colors.transparent,
      textTheme: TextTheme(
        // Заголовки страниц
        headline3: GoogleFonts.rubik(
          color: isDark ? textDark : textLight,
          fontSize: 42.0,
        ),
        // Заголовки абзацев
        headline4: GoogleFonts.rubik(
          color: isDark ? textDark : textLight,
          fontWeight: FontWeight.w300,
          fontSize: 38.0,
        ),
        bodyText1: GoogleFonts.raleway(
          color: isDark ? textDark : textLight,
          fontSize: 22.0,
        ),
        // Меню
        overline: GoogleFonts.comfortaa(
          color: isDark ? textDark : textLight,
          fontSize: 24.0,
        ),
        button: GoogleFonts.comfortaa(
          fontSize: 18.0,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
