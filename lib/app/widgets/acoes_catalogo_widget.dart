import 'package:flutter/material.dart';
import 'package:primor/app/widgets/edtQuantidade_widget.dart';

import '../controllers/carinho_controller.dart';
import '../models/catalogo/catalogo_model.dart';
import 'botao_widget.dart';

class AcoesCatalogoWidget extends StatelessWidget {
  const AcoesCatalogoWidget({
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Botao(
          size: const Size(30, 30),
          cor: Colors.red,
          icone: Icons.remove,
          onClick: () {
            carrinhoController.removeItem(catalogoModel.codigo!);
          },
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 50,
          height: 50,
          child: EdtQuantidadeWidget(
            index: index,
            catalogoModel: catalogoModel,
            carrinhoController: carrinhoController,
          ),
        ),
        const SizedBox(width: 10),
        Botao(
          size: const Size(30, 30),
          cor: Colors.green,
          icone: Icons.add,
          onClick: () {
            carrinhoController.addItem(catalogoModel, 1);
          },
        ),
      ],
    );
  }
}
