import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';
import '../models/catalogo/catalogo_model.dart';

class EdtQuantidadeWidget extends StatelessWidget {
  const EdtQuantidadeWidget({
    super.key,
    required this.index,
    required this.catalogoModel,
    required this.carrinhoController,
  });

  final int index;
  final CatalogoModel catalogoModel;
  final CarrinhoController carrinhoController;

  @override
  Widget build(BuildContext context) {
    final edtQuantidade = TextEditingController(
        text: carrinhoController.itens.isNotEmpty
            ? index < 0
                ? '0'
                : carrinhoController.itens[index].quantidade.toStringAsFixed(0)
            : '0');
    if (edtQuantidade.text.isNotEmpty) {
      edtQuantidade.selection = TextSelection(
        baseOffset: 0,
        extentOffset: edtQuantidade.text.length,
      );
    }
    return TextFormField(
      onTap: () {
        if (edtQuantidade.text.isNotEmpty) {
          edtQuantidade.selection = TextSelection(
            baseOffset: 0,
            extentOffset: edtQuantidade.text.length,
          );
        }
      },
      controller: edtQuantidade,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        if (value.isEmpty) {
          return;
        }
        if (carrinhoController.itens[index].quantidade == 0) {
          carrinhoController.addItem(catalogoModel, double.parse(value));
        } else {
          carrinhoController.setQuantidade(
              carrinhoController.itens[index].codigo, double.parse(value));
        }
      },
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
