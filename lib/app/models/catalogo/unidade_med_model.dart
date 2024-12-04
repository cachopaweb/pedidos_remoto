import 'dart:convert';

class UnidadeMedModel {
  int? codigo;
  String? unidade;
  String? descricao;

  UnidadeMedModel({this.codigo, this.unidade, this.descricao});

  factory UnidadeMedModel.fromMap(Map<String, dynamic> data) => UnidadeMedModel(
        codigo: data['codigo'] as int?,
        unidade: data['unidade'] as String?,
        descricao: data['descricao'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'codigo': codigo,
        'unidade': unidade,
        'descricao': descricao,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UnidadeMedModel].
  factory UnidadeMedModel.fromJson(String data) {
    return UnidadeMedModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UnidadeMedModel] to a JSON string.
  String toJson() => json.encode(toMap());

  UnidadeMedModel copyWith({
    int? codigo,
    String? unidade,
    String? descricao,
  }) {
    return UnidadeMedModel(
      codigo: codigo ?? this.codigo,
      unidade: unidade ?? this.unidade,
      descricao: descricao ?? this.descricao,
    );
  }
}
