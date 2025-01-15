import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';

class ThemesStyle {
  static ThemeData lightTheme(context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ThemeData(
      colorScheme: const ColorScheme(
        brightness: ThemesColors.brightness,
        primary: ThemesColors.primary,
        onPrimary: ThemesColors.onPrimary,
        secondary: ThemesColors.secondary,
        onSecondary: ThemesColors.onSecondary,
        error: ThemesColors.error,
        onError: ThemesColors.onError,
        surface: ThemesColors.surface,
        onSurface: ThemesColors.onSurface,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(textTheme)
          .copyWith(
            headlineLarge: ThemesFonts.headlineLarge(),
            headlineMedium: ThemesFonts.headlineMedium(),
            headlineSmall: ThemesFonts.headlineSmall(),
            titleMedium: ThemesFonts.titleMedium(),
            bodyMedium: ThemesFonts.bodyMedium(),
            bodySmall: ThemesFonts.bodySmall(),
          )
          .apply(fontSizeFactor: 1.0),
    );
  }
}
