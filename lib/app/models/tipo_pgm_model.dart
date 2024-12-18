import 'dart:convert';

class TipoPgmModel {
  int codigo;
  String descricao;
  int? con;
  String nome;
  String? tipo;

  TipoPgmModel({
    required this.codigo,
    required this.descricao,
    this.con,
    required this.nome,
    this.tipo,
  });

  factory TipoPgmModel.fromMap(Map<String, dynamic> data) => TipoPgmModel(
        codigo: data['codigo'] as int,
        descricao: data['descricao'] as String,
        con: data['con'] as int?,
        nome: data['nome'] as String,
        tipo: data['tipo'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'codigo': codigo,
        'descricao': descricao,
        'con': con,
        'nome': nome,
        'tipo': tipo,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TipoPgmModel].
  factory TipoPgmModel.fromJson(String data) {
    return TipoPgmModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TipoPgmModel] to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates an empty [TipoPgmModel].
  factory TipoPgmModel.empty() => TipoPgmModel(
        codigo: 0,
        descricao: 'DINHEIRO',
        con: 0,
        nome: 'DI',
        tipo: 'R',
      );
}
