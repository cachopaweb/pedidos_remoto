import 'dart:convert';

class UsuarioLogado {
  final int codigo;
  final int cliente;
  final String nome;
  final bool mostrarPrecos;
  final String fantasia;

  UsuarioLogado({
    required this.codigo,
    required this.cliente,
    required this.nome,
    required this.mostrarPrecos,
    required this.fantasia,
  });

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'cliente': cliente,
      'nome': nome,
      'mostrar_precos': mostrarPrecos,
      'fantasia': fantasia,
    };
  }

  factory UsuarioLogado.fromMap(Map<String, dynamic> map) {
    return UsuarioLogado(
      codigo: map['codigo'] ?? 0,
      cliente: map['cliente'] ?? 0,
      nome: map['nome'] ?? '',
      mostrarPrecos: map['mostrar_precos'] ?? false,
      fantasia: map['fantasia'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioLogado.fromJson(String source) =>
      UsuarioLogado.fromMap(json.decode(source));
}
