import 'package:flutter/material.dart';
import 'package:pedidos_remoto/app/models/catalogo/catalogo_model.dart';

import 'package:provider/provider.dart';

import '../controllers/usuario_controller.dart';
import '../models/catalogo/produto_model.dart';
import '../widgets/icone_carrinho.dart';
import '../widgets/item_catalogo_widget.dart';

class ItensCatalogoPage extends StatefulWidget {
  final CatalogoModel catalogoModel;

  const ItensCatalogoPage({
    super.key,
    required this.catalogoModel,
  });

  @override
  State<ItensCatalogoPage> createState() => _ItensCatalogoPageState();
}

class _ItensCatalogoPageState extends State<ItensCatalogoPage> {
  final quantidade = ValueNotifier(0.0);

  _buildItens() {
    return SizedBox(
      height: 200,
      child: ItemCatalogoWidget(
        catalogoModel: widget.catalogoModel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioLogado = Provider.of<UsuarioController>(context).usuarioLogado;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          usuarioLogado.mostrarPrecos
              ? widget.catalogoModel.precoVenda!.toStringAsFixed(2)
              : widget.catalogoModel.produto!.nome!,
        ),
        centerTitle: true,
        actions: const [
          IconeCarrinho(),
        ],
      ),
      body: _buildItens(),
    );
  }
}
