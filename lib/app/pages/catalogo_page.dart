// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';
import '../controllers/usuario_controller.dart';
import '../core/core.dart';
import '../models/catalogo/catalogo_model.dart';
import '../models/itens_carrinho.dart';
import '../stores/catalogo_store.dart';
import '../widgets/botao_widget.dart';
import '../widgets/card_item_widget.dart';
import '../widgets/icone_carrinho.dart';
import '../widgets/responsive_widget.dart';

class CatalogoPage extends StatelessWidget {
  final store = CatalogoStore();

  CatalogoPage({super.key});

  _buildBody(Size size, List<CatalogoModel> listaItensCatalogo) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ResponsiveWidget(
              tablet: DataTablePedido(listaItensCatalogo: listaItensCatalogo),
              mobile: ListViewPedido(listaItensCatalogo: listaItensCatalogo),
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
    final usuarioController =
        Provider.of<UsuarioController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTextStyles.titulo),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              store.fetchCatalogo(usuarioController.usuarioLogado.codigo);
            },
            icon: const Icon(Icons.refresh)),
        actions: const [
          IconeCarrinho(),
        ],
      ),
      body: ScopedBuilder<CatalogoStore, List<CatalogoModel>>(
        store: store..fetchCatalogo(usuarioController.usuarioLogado.codigo),
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

class ListViewPedido extends StatelessWidget {
  const ListViewPedido({
    super.key,
    required this.listaItensCatalogo,
  });

  final List<CatalogoModel> listaItensCatalogo;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: listaItensCatalogo
          .map((catalogo) => ItemCatalogoWidget(
                catalogoModel: catalogo,
              ))
          .toList(),
    );
  }
}

class DataTablePedido extends StatelessWidget {
  const DataTablePedido({
    super.key,
    required this.listaItensCatalogo,
  });

  final List<CatalogoModel> listaItensCatalogo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Nome',
                style: AppTextStyles.textBodyBold,
              ))),
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Vlr Unit',
                style: AppTextStyles.textBodyBold,
              ))),
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Total',
                style: AppTextStyles.textBodyBold,
              ))),
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Açôes',
                style: AppTextStyles.textBodyBold,
              ))),
            ],
            rows: listaItensCatalogo.map(
              (catalogo) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(catalogo.produto!.nome!)),
                    DataCell(Text(catalogo.precoVenda!.toStringAsFixed(2))),
                    DataCell(
                      Consumer<CarrinhoController>(
                          builder: (context, controller, child) {
                        var item = Item.empty();
                        if (controller.itens.isNotEmpty) {
                          if (controller.itens
                              .any((e) => e.codigo == catalogo.codigo)) {
                            item = controller.itens
                                .firstWhere((e) => e.codigo == catalogo.codigo);
                          }
                        }
                        return Text(
                          (catalogo.precoVenda! *
                                  (item.codigo > 0 ? item.quantidade : 0.0))
                              .toStringAsFixed(2),
                        );
                      }),
                    ),
                    DataCell(
                      Acoes(
                        catalogoModel: catalogo,
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}

class ItemCatalogoWidget extends StatelessWidget {
  const ItemCatalogoWidget({
    super.key,
    required this.catalogoModel,
  });

  final CatalogoModel catalogoModel;

  List<Widget> _dados(Item item) {
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
                    'Vlr Total: R\$ ${(catalogoModel.precoVenda! * (item.codigo > 0 ? item.quantidade : 0.0)).toStringAsFixed(2)}',
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
      Acoes(catalogoModel: catalogoModel),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final carrinhoController =
        Provider.of<CarrinhoController>(context, listen: true);
    var item = Item.empty();
    if (carrinhoController.itens.isNotEmpty) {
      if (carrinhoController.itens
          .any((e) => e.codigo == catalogoModel.codigo)) {
        item = carrinhoController.itens
            .firstWhere((e) => e.codigo == catalogoModel.codigo);
      }
    }
    return CardItem(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ResponsiveWidget(
          mobile: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _dados(item),
          ),
          tablet: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _dados(item),
          ),
        ),
      ),
    );
  }
}

class Acoes extends StatelessWidget {
  const Acoes({
    super.key,
    required this.catalogoModel,
  });

  final CatalogoModel catalogoModel;

  @override
  Widget build(BuildContext context) {
    final carrinhoController = Provider.of<CarrinhoController>(context);
    var item = Item.empty();
    if (carrinhoController.itens.isNotEmpty) {
      if (carrinhoController.itens
          .any((e) => e.codigo == catalogoModel.codigo)) {
        item = carrinhoController.itens
            .firstWhere((e) => e.codigo == catalogoModel.codigo);
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Botao(
            size: const Size(30, 30),
            cor: Colors.red,
            icone: Icons.remove,
            onClick: () {
              carrinhoController.removeItem(catalogoModel.codigo!);
            }),
        const SizedBox(width: 10),
        SizedBox(
          width: 50,
          height: 50,
          child: EdtQuantidade(
            item: item,
            catalogoModel: catalogoModel,
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

class EdtQuantidade extends StatelessWidget {
  const EdtQuantidade({
    super.key,
    required this.item,
    required this.catalogoModel,
  });

  final Item item;
  final CatalogoModel catalogoModel;

  @override
  Widget build(BuildContext context) {
    final edtQuantidade =
        TextEditingController(text: item.quantidade.toStringAsFixed(0));
    final carrinhoController =
        Provider.of<CarrinhoController>(context, listen: true);
    if (edtQuantidade.text.isNotEmpty) {
      edtQuantidade.selection = TextSelection(
        baseOffset: 0,
        extentOffset: edtQuantidade.text.length,
      );
    }
    return TextFormField(
      autofocus: false,
      autocorrect: false,
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
        if (item.quantidade == 0) {
          carrinhoController.addItem(catalogoModel, double.parse(value));
        } else {
          carrinhoController.setQuantidade(item.codigo, double.parse(value));
        }
      },
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
