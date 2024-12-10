import 'dart:convert';

class UsuarioLogado {
  final int codigo;
  final String login;
  final bool mostrarPrecos;

  UsuarioLogado({
    required this.codigo,
    required this.login,
    required this.mostrarPrecos,
  });

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'login': login,
      'mostrar_precos': mostrarPrecos,
    };
  }

  factory UsuarioLogado.fromMap(Map<String, dynamic> map) {
    return UsuarioLogado(
      codigo: map['codigo'] ?? 0,
      login: map['login'] ?? '',
      mostrarPrecos: map['mostrar_precos'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioLogado.fromJson(String source) =>
      UsuarioLogado.fromMap(json.decode(source));
}
