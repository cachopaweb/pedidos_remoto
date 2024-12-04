import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';

class IconeCarrinho extends StatelessWidget {
  const IconeCarrinho({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carrinhoController = Provider.of<CarrinhoController>(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_rounded),
          onPressed: carrinhoController.totalItens > 0
              ? () {
                  Navigator.of(context).pushNamed('/carrinho');
                }
              : null,
        ),
        carrinhoController.quantidadeItens > 0
            ? Positioned(
                top: 8,
                right: 5,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      carrinhoController.quantidadeItens.toStringAsFixed(0),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
