import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';
import '../models/catalogo/catalogo_model.dart';
import 'item_catalogo_widget.dart';

class ListViewPedido extends StatelessWidget {
  const ListViewPedido({
    super.key,
    required this.listaItensCatalogo,
  });

  final List<CatalogoModel> listaItensCatalogo;

  @override
  Widget build(BuildContext context) {
    final carrinhoController =
        Provider.of<CarrinhoController>(context, listen: true);
    return ListView(
      children: listaItensCatalogo.map((catalogo) {
        final index = carrinhoController.itens.indexWhere(
          (e) => e.codigo == catalogo.codigo,
        );
        return ItemCatalogoWidget(
          catalogoModel: catalogo,
          carrinhoController: carrinhoController,
          index: index,
        );
      }).toList(),
    );
  }
}
