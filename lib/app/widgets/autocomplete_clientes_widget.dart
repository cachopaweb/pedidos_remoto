import 'package:flutter/material.dart';

import 'package:pedidos_remoto/app/models/cliente_model.dart';
import 'package:pedidos_remoto/app/repositories/clientes_repository.dart';

class AutocompleteClientesWidget extends StatefulWidget {
  final ValueNotifier<ClienteModel> clienteSelecionado;

  const AutocompleteClientesWidget({
    super.key,
    required this.clienteSelecionado,
  });

  @override
  State<AutocompleteClientesWidget> createState() =>
      _AutocompleteClientesWidgetState();
}

class _AutocompleteClientesWidgetState
    extends State<AutocompleteClientesWidget> {
  var listaClientes = <ClienteModel>[];
  var listaNomesPesquisar = <String>[];

  @override
  void initState() {
    super.initState();
    _buscarClientes();
  }

  Future<void> _buscarClientes() async {
    try {
      final clientesRepository = ClientesRepository();
      final lista = await clientesRepository.getClientes();

      setState(() {
        listaClientes = lista;
        listaNomesPesquisar = listaClientes.map((e) => e.nome).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        focusNode.requestFocus();
        return TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Informe o Cliente',
          ),
          controller: textEditingController,
          focusNode: focusNode,
          canRequestFocus: true,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return listaNomesPesquisar.where((String option) {
          return option.contains(textEditingValue.text.toUpperCase());
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
        final clienteSelecionado =
            listaClientes.firstWhere((e) => e.nome == selection);
        widget.clienteSelecionado.value = clienteSelecionado;
      },
    );
  }
}
