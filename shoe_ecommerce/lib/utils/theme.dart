import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF5B9EE1);
  static const Color secondaryColor = Color(0xFF5B9EE1);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);
  static const Color redColor = Color(0xFFF87265);
  static const Color textcolor = Color(0xFF1A2530);
  static const Color backgroundColor = Color.fromARGB(255, 248, 248, 249);

  static ThemeData get lightTheme {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: Brightness.dark, 
      ),
    );

    return ThemeData(   fontFamily: "AirbnbCereal",
      primaryColor: primaryColor,
      scaffoldBackgroundColor: whiteColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: whiteColor,
        error: redColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: blackColor),
        bodyMedium: TextStyle(color: blackColor),
      ),
    );
  }
}
