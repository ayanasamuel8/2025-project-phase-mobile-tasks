import 'package:flutter/material.dart';

class CustomColor {
  static const Color black = Color.fromARGB(255, 62, 62, 62);
  static const Color grey = Color.fromARGB(255, 102, 102, 102);
  static const Color primary = Color(0xFF3F51F3);
  static const MaterialColor primarySwatch =
      MaterialColor(0xFF3F51F3, <int, Color>{
        50: primary,
        100: primary,
        200: primary,
        300: primary,
        400: primary,
        500: primary,
        600: primary,
        700: primary,
        800: primary,
        900: primary,
      });
}
