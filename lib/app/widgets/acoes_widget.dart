import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';
import '../models/itens_carrinho.dart';
import 'botao_widget.dart';

class AcoesWidget extends StatelessWidget {
  const AcoesWidget({
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
          child: TextFormField(
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
              carrinhoController.setQuantidade(
                  item.codigo, double.parse(value));
            },
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
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
