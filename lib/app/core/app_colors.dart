import 'package:flutter/material.dart';

class AppColors {
  static Color get primary => const Color.fromRGBO(64, 140, 85, 1);
  static Color get secondary => Colors.white;
  static Color get accent => const Color.fromRGBO(114, 182, 132, 1);
  static LinearGradient get gradientFundo => const LinearGradient(colors: [
        Color.fromRGBO(7, 92, 30, 1),
        Color.fromRGBO(114, 182, 132, 1),
      ]);
}
