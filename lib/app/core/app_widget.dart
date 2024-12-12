import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';
import '../controllers/usuario_controller.dart';
import '../pages/carrinho_page.dart';
import '../pages/catalogo_page.dart';
import '../pages/finalizacao_page.dart';
import '../pages/login_page.dart';
import '../pages/splash_page.dart';
import '../repositories/pedido_repository.dart';
import 'core.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UsuarioController(),
        ),
        ChangeNotifierProvider(
          create: (context) => CarrinhoController(
            PedidoRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppTextStyles.titulo,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                color: AppColors.primary,
                titleTextStyle: AppTextStyles.title,
                iconTheme: const IconThemeData(
                  color: Colors.white,
                )),
            cardTheme: const CardTheme(
              color: Colors.white,
              surfaceTintColor: Colors.white,
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: AppColors.primary,
            )),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/catalogo': (context) => const CatalogoPage(),
          '/carrinho': (context) => const CarrinhoPage(),
          '/finalizacao': (context) => const FinalizacaoPage(),
        },
      ),
    );
  }
}
