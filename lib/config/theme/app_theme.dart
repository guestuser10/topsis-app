import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const colorSeed = Color.fromARGB(255, 64, 80, 255);
const scaffoldBackgroundColor = Color.fromARGB(255, 243, 241, 241);

class AppTheme {
  get getcolor => colorSeed;
  get getBackgroundColor => scaffoldBackgroundColor;
  ThemeData getTheme() => ThemeData(
    ///* General
    useMaterial3: true,
    colorSchemeSeed: colorSeed,
    ///* Texts
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 40, fontWeight: FontWeight.bold ),
      titleMedium: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 30, fontWeight: FontWeight.bold ),
      titleSmall: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 20 )
    ),

    ///* Scaffold Background Color
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    

    ///* Buttons
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll( //MaterialStatePropertyAll
          GoogleFonts.montserratAlternates()
            .copyWith(fontWeight: FontWeight.w700)
          )
      )
    ),

    ///* AppBar
    appBarTheme: AppBarTheme(
      color: scaffoldBackgroundColor,
      titleTextStyle: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black ),
    )
  );

}