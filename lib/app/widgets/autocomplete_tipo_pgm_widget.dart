import 'package:flutter/material.dart';

import '../models/tipo_pgm_model.dart';
import '../repositories/tipo_pgm_repository.dart';

class AutocompleteTipoPgmWidget extends StatefulWidget {
  final ValueNotifier<TipoPgmModel> tipoPgmSelecionado;

  const AutocompleteTipoPgmWidget({
    super.key,
    required this.tipoPgmSelecionado,
  });

  @override
  State<AutocompleteTipoPgmWidget> createState() =>
      _AutocompletetipoPgmWidgetState();
}

class _AutocompletetipoPgmWidgetState extends State<AutocompleteTipoPgmWidget> {
  var listatipoPgm = <TipoPgmModel>[];
  var listaNomesPesquisar = <String>[];

  @override
  void initState() {
    super.initState();
    _buscarTipoPgm();
  }

  Future<void> _buscarTipoPgm() async {
    try {
      final tipoPgmRepository = TipoPgmRepository();
      final lista = await tipoPgmRepository.getTipoPgms();

      setState(() {
        listatipoPgm = lista;
        listaNomesPesquisar = listatipoPgm
            .where((e) => e.tipo == 'R')
            .map((e) => e.descricao)
            .toList();
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
        return TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Informe o Tipo Pgm',
          ),
          controller: textEditingController,
          focusNode: focusNode,
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
        final tipoPgmSelecionado =
            listatipoPgm.firstWhere((e) => e.descricao == selection);
        widget.tipoPgmSelecionado.value = tipoPgmSelecionado;
      },
    );
  }
}
