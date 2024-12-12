import 'package:flutter/material.dart';

class AppColors {
  static Color get primary => const Color.fromRGBO(1, 38, 20, 1);
  static Color get secondary => Colors.white;
  static Color get accent => const Color.fromRGBO(85, 154, 0, 1);
  static LinearGradient get gradientFundo => const LinearGradient(colors: [
        Color.fromRGBO(1, 38, 20, 1),
        Color.fromRGBO(85, 154, 0, 1),
      ]);
}
