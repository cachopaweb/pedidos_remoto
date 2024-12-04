import 'package:flutter/material.dart';

import '../core/core.dart';

class FinalizacaoPage extends StatefulWidget {
  const FinalizacaoPage({super.key});

  @override
  State<FinalizacaoPage> createState() => FinalizacaoPageState();
}

class FinalizacaoPageState extends State<FinalizacaoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Future navigationToCatalogo(BuildContext context) async {
    final navigator = Navigator.of(context);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    navigator.pushReplacementNamed('/catalogo');
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    navigationToCatalogo(context);
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green[500],
                border: const Border.fromBorderSide(
                  BorderSide(width: 4, color: Colors.white),
                ),
              ),
              child: Center(
                child: AnimatedIcon(
                  size: 130,
                  color: Colors.white,
                  icon: AnimatedIcons.menu_arrow,
                  progress: _controller,
                ),
              ),
            ),
            Text(
              'Pedido realizado com sucesso!',
              style: AppTextStyles.textBodyBold,
            )
          ],
        ),
      ),
    );
  }
}
