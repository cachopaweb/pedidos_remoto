// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Item {
  final int codigo;
  double quantidade;
  double? valor;
  final String nome;
  final int codPro;

  Item({
    required this.codigo,
    required this.quantidade,
    this.valor,
    required this.nome,
    required this.codPro,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'quantidade': quantidade,
      'valor': valor,
      'nome': nome,
      'codPro': codPro,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      codigo: map['codigo'] as int,
      quantidade: map['quantidade'] as double,
      valor: map['valor'] != null ? map['valor'] as double : null,
      nome: map['nome'] as String,
      codPro: map['codPro'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Item.empty() => Item(codigo: 0, quantidade: 0, nome: '', codPro: 0);
}
