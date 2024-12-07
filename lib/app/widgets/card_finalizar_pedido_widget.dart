// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

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
          AutocompleteTipoPgmWidget(
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
