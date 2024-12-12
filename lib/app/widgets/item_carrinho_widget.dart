import 'package:flutter/material.dart';
import 'package:pedidos_remoto/app/widgets/responsive_widget.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';
import '../controllers/usuario_controller.dart';
import '../core/core.dart';
import '../models/itens_carrinho.dart';
import 'acoes_widget.dart';
import 'card_item_widget.dart';

class ItemCarrinhoWidget extends StatelessWidget {
  const ItemCarrinhoWidget({
    super.key,
    required this.context,
    required this.itensCarrinho,
    required this.index,
    required this.controller,
  });

  final BuildContext context;
  final List<Item> itensCarrinho;
  final int index;
  final CarrinhoController controller;

  List<Widget> dados() {
    final item = itensCarrinho[index];
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 350,
            child: Text(
              item.nome,
              style: TextStyle(
                fontSize: 20,
                color: AppColors.primary,
              ),
            ),
          ),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    'Vlr Unit: R\$ ${item.valor!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Vlr Total: R\$ ${(item.valor! * item.quantidade).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      AcoesWidget(item: item)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CardItem(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ResponsiveWidget(
            mobile: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: dados(),
            ),
            tablet: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: dados(),
            ),
          ),
        ),
      ),
    );
  }
}
