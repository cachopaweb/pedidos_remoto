// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pedidos_remoto/app/core/core.dart';

import 'package:pedidos_remoto/app/repositories/tipo_pgm_repository.dart';
import 'package:pedidos_remoto/app/widgets/card_item_widget.dart';
import 'package:pedidos_remoto/app/widgets/myinput_text.dart';

import '../models/cliente_model.dart';
import '../models/tipo_pgm_model.dart';
import 'autocomplete_clientes_widget.dart';
import 'autocomplete_tipo_pgm_widget.dart';

class CardFinalizarPedidoWidget extends StatelessWidget {
  const CardFinalizarPedidoWidget({
    super.key,
    required this.clienteController,
    required this.enderecoController,
    required this.tipoPgmController,
    required this.emitNFController,
  });

  final ValueNotifier<ClienteModel> clienteController;
  final TextEditingController enderecoController;
  final ValueNotifier<TipoPgmModel> tipoPgmController;
  final ValueNotifier<bool> emitNFController;

  Widget _buildFormulario() {
    return Form(
      child: Column(
        children: [
          AutocompleteClientesWidget(
            clienteSelecionado: clienteController,
          ),
          const SizedBox(
            height: 10,
          ),
          MyInputText(
            label: 'Endereço',
            icone: const Icon(Icons.account_box),
            controller: enderecoController,
          ),
          const SizedBox(
            height: 10,
          ),
          ComboBoxTipoPgm(
            tipoPgmSelecionado: tipoPgmController,
          ),
          const SizedBox(
            height: 10,
          ),
          RadioButomCustom(
            label: 'Emitir NF',
            controller: emitNFController,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CardItem(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildFormulario(),
        ),
      ),
    );
  }
}

class RadioButomCustom extends StatelessWidget {
  const RadioButomCustom({
    super.key,
    required this.controller,
    required this.label,
  });

  final ValueNotifier<bool> controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller,
      builder: (context, checked, child) {
        return Row(
          children: [
            Text(label),
            Checkbox(
              checkColor: Colors.white,
              value: checked,
              onChanged: (bool? value) {
                controller.value = value!;
              },
            ),
          ],
        );
      },
    );
  }
}

class ComboBoxTipoPgm extends StatefulWidget {
  const ComboBoxTipoPgm({
    super.key,
    required this.tipoPgmSelecionado,
  });

  final ValueNotifier<TipoPgmModel> tipoPgmSelecionado;

  @override
  State<ComboBoxTipoPgm> createState() => _ComboBoxTipoPgmState();
}

class _ComboBoxTipoPgmState extends State<ComboBoxTipoPgm> {
  var listaTipoPgm = <TipoPgmModel>[];
  late final TipoPgmRepository tipoPgmRepository;
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    tipoPgmRepository = TipoPgmRepository();
    _buscarTipoPgm();
  }

  _buscarTipoPgm() async {
    try {
      setState(() {
        carregando = true;
      });
      final lista = await tipoPgmRepository.getTipoPgms();
      setState(() {
        listaTipoPgm = lista;
        carregando = false;
      });
    } catch (e) {
      _buildError();
      setState(() {
        carregando = false;
      });
    }
  }

  _buildError() {
    return const Text('Erro ao buscar tipo pgm!');
  }

  _buildCarregando() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var descricao = 'DINHEIRO';
    if (listaTipoPgm.isNotEmpty) {
      final result = listaTipoPgm.firstWhere(
        (e) => e.descricao == widget.tipoPgmSelecionado.value.descricao,
        orElse: () => TipoPgmModel.empty(),
      );
      if (result.codigo > 0) {
        descricao = result.descricao;
      }
    }
    return carregando
        ? _buildCarregando()
        : SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
              value: descricao,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: TextStyle(color: AppColors.primary),
              underline: Container(
                height: 2,
                color: AppColors.accent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  if (value != null || value!.isNotEmpty) {
                    final tipoPgm =
                        listaTipoPgm.firstWhere((e) => e.descricao == value);
                    widget.tipoPgmSelecionado.value = tipoPgm;
                  }
                });
              },
              items: listaTipoPgm
                  .map<DropdownMenuItem<String>>((TipoPgmModel value) {
                return DropdownMenuItem<String>(
                  value: value.descricao,
                  child: Text(value.descricao),
                );
              }).toList(),
            ),
          );
  }
}
