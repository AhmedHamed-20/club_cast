import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
  backgroundColor: Colors.grey[800],
  textTheme: TextTheme(
    bodyText1: GoogleFonts.rubik(
      color: Colors.white,
      fontSize: 18,
    ),
    bodyText2: GoogleFonts.rubik(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  scaffoldBackgroundColor: Color(0x2BE5E5E5),
  primaryColor: Color(
    0xff6A4CFF,
  ),
);

ThemeData lightMode = ThemeData(
  backgroundColor: Colors.white,
  textTheme: TextTheme(
    bodyText1: GoogleFonts.rubik(
      fontSize: 18,
      color: const Color(0xff59675B),
    ),
    bodyText2: GoogleFonts.rubik(
      color: const Color(0xff59675B),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  appBarTheme: const AppBarTheme(
    titleSpacing: 20,
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(),
    backgroundColor: Color(0xffF6F9F4),
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xff59675B),
  ),
  scaffoldBackgroundColor: const Color(0xffF6F9F4),
  primaryColor: const Color(0xff5ADAAC),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Color(0xff5ADAAC),
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: false,
    elevation: 20,
    backgroundColor: Colors.white,
    selectedIconTheme: IconThemeData(
      size: 30,
    ),
    unselectedIconTheme: IconThemeData(
      size: 25,
    ),
  ),
  //  backgroundColor: Color(0xffF6F9F4),
);
