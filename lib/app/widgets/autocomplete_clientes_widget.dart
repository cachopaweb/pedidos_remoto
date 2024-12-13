import 'package:flutter/material.dart';

import '../models/cliente_model.dart';
import '../repositories/clientes_repository.dart';

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
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    _buscarClientes('');
  }

  Future<void> _buscarClientes(String busca) async {
    if (busca.length < 3) {
      return;
    }
    try {
      setState(() {
        carregando = true;
      });
      final clientesRepository = ClientesRepository();
      final lista = await clientesRepository.getClientes(busca);

      setState(() {
        listaClientes = lista;
        carregando = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        carregando = false;
      });
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
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        if (textEditingValue.text.length > 3) {
          await _buscarClientes(textEditingValue.text);
        }
        return listaClientes.map((e) => e.nome).where((nome) =>
            nome.toUpperCase().contains(textEditingValue.text.toUpperCase()));
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
