import 'package:flutter/material.dart';
import 'package:primor/app/controllers/carinho_controller.dart';
import 'package:provider/provider.dart';

import '../core/core.dart';
import '../models/catalogo/catalogo_model.dart';
import 'acoes_catalogo_widget.dart';

class DataTablePedido extends StatelessWidget {
  const DataTablePedido({
    super.key,
    required this.listaItensCatalogo,
  });

  final List<CatalogoModel> listaItensCatalogo;

  @override
  Widget build(BuildContext context) {
    final carrinhoController =
        Provider.of<CarrinhoController>(context, listen: true);
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
                final index = carrinhoController.itens.indexWhere(
                  (e) => e.codigo == catalogo.codigo,
                );
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(catalogo.produto!.nome!)),
                    DataCell(Text(catalogo.precoVenda!.toStringAsFixed(2))),
                    DataCell(
                      Text(
                        index < 0
                            ? '0'
                            : (catalogo.precoVenda! *
                                    (carrinhoController.itens[index].codigo > 0
                                        ? carrinhoController
                                            .itens[index].quantidade
                                        : 0.0))
                                .toStringAsFixed(2),
                      ),
                    ),
                    DataCell(
                      AcoesCatalogoWidget(
                        catalogoModel: catalogo,
                        index: index,
                        carrinhoController: carrinhoController,
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
