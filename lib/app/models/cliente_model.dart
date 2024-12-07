import 'dart:convert';

class ClienteModel {
  int codigo;
  String nome;
  String cnpjCpf;
  String? endereco;

  ClienteModel(
      {required this.codigo,
      required this.nome,
      required this.cnpjCpf,
      this.endereco});

  factory ClienteModel.fromMap(Map<String, dynamic> data) => ClienteModel(
        codigo: data['codigo'] as int,
        nome: data['nome'] as String,
        cnpjCpf: data['cnpj_cpf'] as String,
        endereco: data['endereco'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'codigo': codigo,
        'nome': nome,
        'cnpj_cpf': cnpjCpf,
        'endereco': endereco,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ClienteModel].
  factory ClienteModel.fromJson(String data) {
    return ClienteModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// Empty factory constructor for creating a new ClienteModel instance
  factory ClienteModel.empty() =>
      ClienteModel(codigo: 0, nome: '', cnpjCpf: '');

  /// `dart:convert`
  ///
  /// Converts [ClienteModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
