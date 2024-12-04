import 'package:flutter/cupertino.dart';

import 'core.dart';

class AppTextStyles {
  static String titulo = 'Cerealista Primor';

  static TextStyle get title => TextStyle(
        color: AppColors.secondary,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      );
  static TextStyle get textBody => TextStyle(
        color: AppColors.primary,
        fontSize: 15,
      );

  static TextStyle get textBodyBold => TextStyle(
      color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold);
}
