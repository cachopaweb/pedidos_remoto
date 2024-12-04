import 'dart:convert';

import 'unidade_med_model.dart';

class ProdutoModel {
  int? codigo;
  int? codFor;
  int? quantidade;
  double? valorv;
  String? codbarra;
  String? nome;
  String? estado;
  int? um;
  UnidadeMedModel? unidadeMed;

  ProdutoModel({
    this.codigo,
    this.codFor,
    this.quantidade,
    this.valorv,
    this.codbarra,
    this.nome,
    this.estado,
    this.um,
    this.unidadeMed,
  });

  factory ProdutoModel.fromMap(Map<String, dynamic> data) => ProdutoModel(
        codigo: data['codigo'] as int?,
        codFor: data['codFor'] as int?,
        quantidade: data['quantidade'] as int?,
        valorv: data['valorv'] as double?,
        codbarra: data['codbarra'] as String?,
        nome: data['nome'] as String?,
        estado: data['estado'] as String?,
        um: data['um'] as int?,
        unidadeMed: data['unidadeMed'] == null
            ? null
            : UnidadeMedModel.fromMap(
                data['unidadeMed'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'codigo': codigo,
        'codFor': codFor,
        'quantidade': quantidade,
        'valorv': valorv,
        'codbarra': codbarra,
        'nome': nome,
        'estado': estado,
        'um': um,
        'unidadeMed': unidadeMed?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProdutoModel].
  factory ProdutoModel.fromJson(String data) {
    return ProdutoModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProdutoModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ProdutoModel copyWith({
    int? codigo,
    int? codFor,
    int? quantidade,
    double? valorv,
    String? codbarra,
    String? nome,
    String? estado,
    int? um,
    UnidadeMedModel? unidadeMed,
  }) {
    return ProdutoModel(
      codigo: codigo ?? this.codigo,
      codFor: codFor ?? this.codFor,
      quantidade: quantidade ?? this.quantidade,
      valorv: valorv ?? this.valorv,
      codbarra: codbarra ?? this.codbarra,
      nome: nome ?? this.nome,
      estado: estado ?? this.estado,
      um: um ?? this.um,
      unidadeMed: unidadeMed ?? this.unidadeMed,
    );
  }
}
