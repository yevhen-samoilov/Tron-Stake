import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tron_stake/themes/theme_colors.dart';

class ThemesFonts {
  static TextStyle large({Color color = ThemesColors.black}) =>
      GoogleFonts.poppins(
          color: color, fontSize: 48, fontWeight: FontWeight.bold);

  static TextStyle headlineLarge({Color color = ThemesColors.black}) =>
      GoogleFonts.poppins(
          color: color, fontSize: 34, fontWeight: FontWeight.bold);

  static TextStyle headlineMedium({Color color = ThemesColors.black}) =>
      GoogleFonts.poppins(
          color: color, fontSize: 28, fontWeight: FontWeight.bold);

  static TextStyle headlineSmall({Color color = ThemesColors.black}) =>
      GoogleFonts.poppins(
          color: color, fontSize: 22, fontWeight: FontWeight.bold);

  static TextStyle titleMedium({Color color = ThemesColors.black}) =>
      GoogleFonts.poppins(
          color: color, fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle bodyMedium(
          {Color color = ThemesColors.black, TextDecoration? decoration}) =>
      GoogleFonts.poppins(
          color: color,
          fontSize: 17,
          decoration: decoration,
          fontWeight: FontWeight.normal);
  static TextStyle bodyMediumBold(
          {Color color = ThemesColors.black, TextDecoration? decoration}) =>
      GoogleFonts.poppins(
          color: color,
          fontSize: 17,
          decoration: decoration,
          fontWeight: FontWeight.bold);
  static TextStyle bodyMediumBold14(
          {Color color = ThemesColors.black, TextDecoration? decoration}) =>
      GoogleFonts.poppins(
          color: color,
          fontSize: 14,
          decoration: decoration,
          fontWeight: FontWeight.bold);

  static TextStyle link(
          {Color color = ThemesColors.primary, TextDecoration? decoration}) =>
      GoogleFonts.poppins(
          color: color,
          fontSize: 17,
          decoration: decoration,
          fontWeight: FontWeight.normal);

  static TextStyle bodySmall(
          {Color color = ThemesColors.black,
          Color? backgroundColor,
          TextDecoration? decoration}) =>
      GoogleFonts.poppins(
          color: color,
          fontSize: 15,
          decoration: decoration,
          fontWeight: FontWeight.normal,
          backgroundColor: backgroundColor);

  static TextStyle small(
          {Color color = ThemesColors.black,
          Color? backgroundColor,
          TextDecoration? decoration}) =>
      GoogleFonts.poppins(
          color: color,
          fontSize: 13,
          decoration: decoration,
          fontWeight: FontWeight.normal,
          backgroundColor: backgroundColor);

  static TextStyle smallS(
          {Color color = ThemesColors.black,
          Color? backgroundColor,
          TextDecoration? decoration}) =>
      GoogleFonts.poppins(
          color: color,
          fontSize: 11,
          decoration: decoration,
          fontWeight: FontWeight.normal,
          backgroundColor: backgroundColor);

  static TextStyle smallX2(
          {Color color = ThemesColors.black,
          Color? backgroundColor,
          TextDecoration? decoration}) =>
      GoogleFonts.poppins(
          color: color,
          fontSize: 9,
          decoration: decoration,
          fontWeight: FontWeight.w100,
          backgroundColor: backgroundColor);

  static TextStyle smallX22(
          {Color color = ThemesColors.black,
          Color? backgroundColor,
          TextDecoration? decoration}) =>
      GoogleFonts.poppins(
          color: color,
          fontSize: 9,
          decoration: decoration,
          fontWeight: FontWeight.w300,
          backgroundColor: backgroundColor);

  static TextStyle smallBold(
          {Color color = ThemesColors.black,
          Color? backgroundColor,
          TextDecoration? decoration}) =>
      GoogleFonts.poppins(
          color: color,
          fontSize: 13,
          decoration: decoration,
          fontWeight: FontWeight.bold,
          backgroundColor: backgroundColor);

  static TextStyle smallSBold(
          {Color color = ThemesColors.black,
          Color? backgroundColor,
          TextDecoration? decoration}) =>
      GoogleFonts.poppins(
          color: color,
          fontSize: 11,
          decoration: decoration,
          fontWeight: FontWeight.bold,
          backgroundColor: backgroundColor);
}
