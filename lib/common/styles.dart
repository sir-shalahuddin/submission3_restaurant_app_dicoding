import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFFAD8B73);
const Color secondaryColor = Color(0xFFCEAB93);
const Color thirdColor = Color(0xFFE3CAA5);
const Color fourthColor = Color(0xFFFFFBE9);

final TextTheme myTextTheme = TextTheme(
  headline1: GoogleFonts.playfairDisplay(
      fontSize: 92, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: GoogleFonts.playfairDisplay(
      fontSize: 57, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3:
      GoogleFonts.playfairDisplay(fontSize: 46, fontWeight: FontWeight.w400),
  headline4:
      GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold),
  headline5:
      GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold),
  headline6: GoogleFonts.playfairDisplay(
      fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.15),
  subtitle1: GoogleFonts.playfairDisplay(
      fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.15),
  subtitle2: GoogleFonts.playfairDisplay(
      fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: GoogleFonts.libreFranklin(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.libreFranklin(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.libreFranklin(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.libreFranklin(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.libreFranklin(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);
