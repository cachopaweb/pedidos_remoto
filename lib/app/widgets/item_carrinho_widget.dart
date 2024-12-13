import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';
import '../core/core.dart';
import '../models/itens_carrinho.dart';
import 'botao_widget.dart';
import 'card_item_widget.dart';
import 'responsive_widget.dart';

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

  List<Widget> dados(Size size) {
    final item = itensCarrinho[index];
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width * 0.7,
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
    final size = MediaQuery.of(context).size;
    return SizedBox(
      child: CardItem(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ResponsiveWidget(
            mobile: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: dados(size),
            ),
            tablet: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: dados(size),
            ),
          ),
        ),
      ),
    );
  }
}

class AcoesWidget extends StatelessWidget {
  const AcoesWidget({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
    final carrinhoController = Provider.of<CarrinhoController>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Botao(
            size: const Size(35, 35),
            cor: Colors.red,
            icone: Icons.remove,
            onClick: () {
              carrinhoController.decrementaQuantidade(item.codigo);
            }),
        const SizedBox(width: 10),
        SizedBox(
          width: 50,
          height: 50,
          child: EdtQuantidade(item: item),
        ),
        const SizedBox(width: 10),
        Botao(
          size: const Size(35, 35),
          cor: Colors.green,
          icone: Icons.add,
          onClick: () {
            carrinhoController.incrementaQuantidade(item.codigo);
          },
        ),
      ],
    );
  }
}

class EdtQuantidade extends StatelessWidget {
  const EdtQuantidade({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
    final carrinhoController =
        Provider.of<CarrinhoController>(context, listen: true);
    final edtQuantidade = TextEditingController(
        text: item.quantidade > 0 ? item.quantidade.toStringAsFixed(0) : '0');
    if (edtQuantidade.text.isNotEmpty) {
      edtQuantidade.selection = TextSelection(
        baseOffset: 0,
        extentOffset: edtQuantidade.text.length,
      );
    }
    return TextFormField(
      keyboardType: TextInputType.number,
      onTap: () {
        if (edtQuantidade.text.isNotEmpty) {
          edtQuantidade.selection = TextSelection(
            baseOffset: 0,
            extentOffset: edtQuantidade.text.length,
          );
        }
      },
      textAlign: TextAlign.center,
      controller: edtQuantidade,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        if (value.isEmpty) {
          return;
        }
        carrinhoController.setQuantidade(item.codigo, double.parse(value));
      },
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
