// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';
import '../controllers/usuario_controller.dart';
import '../core/core.dart';
import '../models/catalogo/catalogo_model.dart';
import '../stores/catalogo_store.dart';
import '../widgets/datatable_pedidos.dart';
import '../widgets/icone_carrinho.dart';
import '../widgets/listview_pedidos.dart';
import '../widgets/responsive_widget.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final store = CatalogoStore();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      final usuarioController = UsuarioController.instance;
      store.fetchCatalogo(usuarioController.usuarioLogado.codigo);
    }
  }

  _buildBody(Size size, List<CatalogoModel> listaItensCatalogo) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ResponsiveWidget(
              tablet: DataTablePedido(
                listaItensCatalogo: listaItensCatalogo,
              ),
              mobile: ListViewPedido(
                listaItensCatalogo: listaItensCatalogo,
              ),
            ),
          ),
          _panelPrecos(),
        ],
      ),
    );
  }

  Container _panelPrecos() {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Center(
        child:
            Consumer<CarrinhoController>(builder: (context, controller, child) {
          return Text(
            'Total R\$ ${controller.valorTotal.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          );
        }),
      ),
    );
  }

  _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildError() {
    return const Center(
      child: Text(
        'Erro ao buscar catalogo!',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTextStyles.titulo),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              store.fetchCatalogo(
                  UsuarioController.instance.usuarioLogado.codigo);
            },
            icon: const Icon(Icons.refresh)),
        actions: const [
          IconeCarrinho(),
        ],
      ),
      body: ScopedBuilder<CatalogoStore, List<CatalogoModel>>(
        store: store,
        onError: (_, e) => _buildError(),
        onLoading: (_) => _buildLoading(),
        onState: (_, state) => _buildBody(
          size,
          state,
        ),
      ),
    );
  }
}
