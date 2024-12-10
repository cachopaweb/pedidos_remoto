import 'package:flutter/material.dart';
import 'package:pedidos_remoto/app/models/itens_carrinho.dart';

import 'package:pedidos_remoto/app/widgets/botao_widget.dart';
import 'package:provider/provider.dart';

import '../controllers/carinho_controller.dart';
import '../controllers/usuario_controller.dart';
import '../core/core.dart';
import '../models/catalogo/catalogo_model.dart';

import '../repositories/catalogo_repository.dart';
import '../widgets/icone_carrinho.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  CatalogoPageState createState() => CatalogoPageState();
}

class CatalogoPageState extends State<CatalogoPage> {
  final repository = CatalogoRepository();
  @override
  void initState() {
    super.initState();
  }

  _buildBody(List<CatalogoModel> listaItensCatalogo, String login) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Center(
              child: Text.rich(
                TextSpan(
                  text: 'Seja bem vindo(a), ',
                  children: [
                    TextSpan(
                      text: 'Usuário: ',
                      children: [
                        TextSpan(
                          text: login,
                          style: AppTextStyles.textBodyBold,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: DataTablePedido(listaItensCatalogo: listaItensCatalogo),
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
    final usuarioController = Provider.of<UsuarioController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTextStyles.titulo),
        centerTitle: true,
        actions: const [
          IconeCarrinho(),
        ],
      ),
      body: FutureBuilder<List<CatalogoModel>>(
        future: repository.getCatalogo(),
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final listaCatalogo = snapshot.data!;
            return _buildBody(
              listaCatalogo,
              usuarioController.usuarioLogado.login,
            );
          }
          if (snapshot.hasError) {
            return _buildError();
          }
          return _buildLoading();
        },
      ),
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
                    DataCell(
                        Text(catalogo.produto!.valorv!.toStringAsFixed(2))),
                    DataCell(
                      Consumer<CarrinhoController>(
                          builder: (context, controller, child) {
                        var item = Item.empty();
                        if (controller.itens.isNotEmpty) {
                          if (controller.itens
                              .any((e) => e.codigo == catalogo.codProduto)) {
                            item = controller.itens.firstWhere(
                                (e) => e.codigo == catalogo.codProduto);
                          }
                        }
                        return Text(
                          (catalogo.produto!.valorv! *
                                  (item.codigo > 0 ? item.quantidade : 0.0))
                              .toStringAsFixed(2),
                        );
                      }),
                    ),
                    DataCell(
                      Consumer<CarrinhoController>(
                          builder: (context, controller, child) {
                        return Acoes(
                          catalogoModel: catalogo,
                        );
                      }),
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

class Acoes extends StatelessWidget {
  const Acoes({
    super.key,
    required this.catalogoModel,
  });

  final CatalogoModel catalogoModel;

  @override
  Widget build(BuildContext context) {
    final carrinhoController =
        Provider.of<CarrinhoController>(context, listen: true);
    var item = Item.empty();
    if (carrinhoController.itens.isNotEmpty) {
      if (carrinhoController.itens
          .any((e) => e.codigo == catalogoModel.codProduto)) {
        item = carrinhoController.itens
            .firstWhere((e) => e.codigo == catalogoModel.codProduto);
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
              carrinhoController.removeItem(catalogoModel.codProduto!);
            }),
        const SizedBox(width: 10),
        Text(
          item.quantidade.toStringAsFixed(0),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Botao(
          size: const Size(30, 30),
          cor: Colors.green,
          icone: Icons.add,
          onClick: () {
            carrinhoController.addItem(catalogoModel.produto!);
          },
        ),
      ],
    );
  }
}
