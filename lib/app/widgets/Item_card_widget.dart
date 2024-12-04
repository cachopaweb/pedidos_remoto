import 'package:flutter/material.dart';
import 'package:pedidos_remoto/app/core/core.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';
import '../models/catalogo/produto_model.dart';
import '../pages/itens_catalogo_page.dart';

class ItemCardWidget extends StatefulWidget {
  final ProdutoModel produtoModel;

  const ItemCardWidget({
    super.key,
    required this.produtoModel,
  });

  @override
  ItemWidgetState createState() => ItemWidgetState();
}

class ItemWidgetState extends State<ItemCardWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    ;
    final controller = Provider.of<CarrinhoController>(context);
    final haveItemList = controller.itens.where((e) {
      return widget.produtoModel.codigo == e.codigo;
    }).toList();
    ////
    isSelected = haveItemList.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ItensCatalogoPage(
              produtoModel: widget.produtoModel,
            ),
          ),
        );
      },
      child: Card(
        elevation: 14,
        child: ListTile(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Código',
                style: AppTextStyles.textBodyBold,
              ),
              Text(widget.produtoModel.codigo.toString()),
            ],
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Nome',
                style: AppTextStyles.textBodyBold,
              ),
              Text(widget.produtoModel.nome!),
            ],
          ),
          trailing: isSelected ? const IconDone() : const SizedBox(height: 1),
        ),
      ),
    );
  }
}

class IconDone extends StatelessWidget {
  const IconDone({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green[500],
        border: const Border.fromBorderSide(
          BorderSide(width: 4, color: Colors.white),
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.done,
          size: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}
