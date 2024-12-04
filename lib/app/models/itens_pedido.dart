import 'dart:convert';

class ItensPedido {
  int? codigo;
  int? pro;
  double? quantidade;
  double? valor;
  int? ped;
  String? nome;

  ItensPedido({
    this.codigo,
    this.pro,
    this.quantidade,
    this.valor,
    this.ped,
    this.nome,
  });

  factory ItensPedido.fromMap(Map<String, dynamic> data) => ItensPedido(
        codigo: data['codigo'] as int?,
        pro: data['pro'] as int?,
        quantidade: data['quantidade'] as double?,
        valor: data['valor'] as double?,
        ped: data['ped'] as int?,
        nome: data['nome'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'codigo': codigo,
        'Pro': pro,
        'quantidade': quantidade,
        'valor': valor,
        'ped': ped,
        'nome': nome,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ItensPedido].
  factory ItensPedido.fromJson(String data) {
    return ItensPedido.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ItensPedido] to a JSON string.
  String toJson() => json.encode(toMap());

  ItensPedido copyWith({
    int? codigo,
    int? pro,
    double? quantidade,
    double? valor,
    int? ped,
    String? nome,
  }) {
    return ItensPedido(
      codigo: codigo ?? this.codigo,
      pro: pro ?? this.pro,
      quantidade: quantidade ?? this.quantidade,
      valor: valor ?? this.valor,
      ped: ped ?? this.ped,
      nome: nome ?? this.nome,
    );
  }
}
