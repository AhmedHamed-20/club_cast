import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    modalBackgroundColor: Colors.transparent,
  ),
  appBarTheme: const AppBarTheme(
    titleSpacing: 20,
    systemOverlayStyle: SystemUiOverlayStyle(),
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  backgroundColor: const Color.fromRGBO(49, 49, 52, 1),
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
  iconTheme: const IconThemeData(
    color: Colors.white,
    size: 28,
  ),
  scaffoldBackgroundColor: Colors.grey[900],
  primaryColor: const Color(
    0xff6A4CFF,
  ),
);

ThemeData lightMode = ThemeData(
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    modalBackgroundColor: Colors.transparent,
  ),
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
    size: 28,
  ),
  scaffoldBackgroundColor: const Color(0xffF6F9F4),
  primaryColor: const Color(0xff5ADAAC),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Color(0xff5ADAAC),
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: false,
    showSelectedLabels: false,
    elevation: 20,
    backgroundColor: Colors.white,
    selectedIconTheme: IconThemeData(
      size: 28,
    ),
    unselectedIconTheme: IconThemeData(
      size: 25,
    ),
  ),
  //  backgroundColor: Color(0xffF6F9F4),
);
