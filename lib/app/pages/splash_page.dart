import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../widgets/logo_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  _goToLogin(BuildContext _) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(_).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    _goToLogin(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.gradientFundo,
      ),
      child: const Center(
        child: LogoWidget(),
      ),
    );
  }
}
