import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';
import '../core/core.dart';
import '../models/catalogo/catalogo_model.dart';
import '../models/itens_carrinho.dart';
import 'acoes_catalogo_widget.dart';
import 'card_item_widget.dart';
import 'responsive_widget.dart';

class ItemCatalogoWidget extends StatelessWidget {
  const ItemCatalogoWidget({
    super.key,
    required this.index,
    required this.catalogoModel,
    required this.carrinhoController,
  });

  final int index;
  final CatalogoModel catalogoModel;
  final CarrinhoController carrinhoController;

  List<Widget> _dados(int index) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 350,
            child: Text(
              catalogoModel.produto!.nome!,
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
                    'Vlr Unit: R\$ ${catalogoModel.precoVenda!.toStringAsFixed(2)}',
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
                    'Vlr Total: R\$ ${index < 0 ? 0 : (catalogoModel.precoVenda! * (carrinhoController.itens[index].codigo > 0 ? carrinhoController.itens[index].quantidade : 0.0)).toStringAsFixed(2)}',
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
      AcoesCatalogoWidget(
        catalogoModel: catalogoModel,
        index: index,
        carrinhoController: carrinhoController,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final carrinhoController =
        Provider.of<CarrinhoController>(context, listen: false);
    final index = carrinhoController.itens.indexWhere(
      (e) => e.codigo == catalogoModel.codigo,
    );
    return CardItem(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ResponsiveWidget(
          mobile: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _dados(index),
          ),
          tablet: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _dados(index),
          ),
        ),
      ),
    );
  }
}
