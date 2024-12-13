import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';
import '../models/catalogo/catalogo_model.dart';
import 'botao_widget.dart';
import 'card_item_widget.dart';

class ItemCatalogoWidget extends StatefulWidget {
  final CatalogoModel catalogoModel;

  const ItemCatalogoWidget({
    super.key,
    required this.catalogoModel,
  });

  @override
  State<ItemCatalogoWidget> createState() => _ItemCatalogoWidgetState();
}

class _ItemCatalogoWidgetState extends State<ItemCatalogoWidget> {
  Widget _buildBody(BuildContext context, Widget Function() produto) {
    return Material(
      child: CardItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  produto(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CarrinhoController>(context);
    Widget catalogo() {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: DetalheProduto(
          catalogoModel: widget.catalogoModel,
          controller: controller,
        ),
      );
    }

    return _buildBody(context, catalogo);
  }
}

class DetalheProduto extends StatefulWidget {
  final CatalogoModel catalogoModel;
  final CarrinhoController controller;

  const DetalheProduto({
    super.key,
    required this.catalogoModel,
    required this.controller,
  });

  @override
  State<DetalheProduto> createState() => DetalheProdutoState();
}

class DetalheProdutoState extends State<DetalheProduto> {
  final quantidade = ValueNotifier<double>(0.0);
  @override
  void initState() {
    super.initState();
    _vinculaItensCarrinho();
    widget.controller.addListener(() {
      _vinculaItensCarrinho();
    });
  }

  _vinculaItensCarrinho() {
    var index = widget.controller.itens
        .indexWhere((element) => element.codigo == widget.catalogoModel.codigo);
    if (index >= 0) {
      if (index >= 0) {
        quantidade.value = widget.controller.itens[index].quantidade;
      }
    } else {
      quantidade.value = 0;
    }
  }

  _removeItem() {
    widget.controller.removeItem(widget.catalogoModel.codigo!);
  }

  _addItem() {
    widget.controller.addItem(widget.catalogoModel, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(
        height: 20,
      ),
      ValueListenableBuilder<double>(
        valueListenable: quantidade,
        builder: (context, qtd, _) {
          return Text(
            qtd.toStringAsFixed(0),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
      const SizedBox(height: 10),
      acoes(),
      const SizedBox(
        height: 20,
      ),
    ]);
  }

  Row acoes() {
    return Row(
      children: [
        Botao(
          size: const Size(60, 60),
          cor: Colors.green,
          icone: Icons.add,
          onClick: () {
            _addItem();
          },
        ),
        const SizedBox(width: 30),
        Botao(
          size: const Size(60, 60),
          icone: Icons.remove,
          cor: Colors.red,
          onClick: () {
            _removeItem();
          },
        ),
      ],
    );
  }
}
