import 'dart:convert';

import 'produto_model.dart';

class CatalogoModel {
  int? codigo;
  int? codProduto;
  double? precoVenda;
  DateTime? dataCadastro;
  int? funCadastrou;
  DateTime? dataAlteracao;
  int? codUsuario;
  ProdutoModel? produto;

  CatalogoModel({
    this.codigo,
    this.codProduto,
    this.precoVenda,
    this.dataCadastro,
    this.funCadastrou,
    this.dataAlteracao,
    this.codUsuario,
    this.produto,
  });

  factory CatalogoModel.fromMap(Map<String, dynamic> data) => CatalogoModel(
        codigo: data['codigo'] as int?,
        codProduto: data['codProduto'] as int?,
        precoVenda: ((data['precoVenda'] / 100) * 100) as double?,
        dataCadastro: data['dataCadastro'] == null
            ? null
            : DateTime.parse(data['dataCadastro'] as String),
        funCadastrou: data['funCadastrou'] as int?,
        dataAlteracao: data['dataAlteracao'] == null
            ? null
            : DateTime.parse(data['dataAlteracao'] as String),
        codUsuario: data['codUsuario'] as int?,
        produto: data['produto'] == null
            ? null
            : ProdutoModel.fromMap(data['produto'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'codigo': codigo,
        'codProduto': codProduto,
        'precoVenda': precoVenda,
        'dataCadastro': dataCadastro?.toIso8601String(),
        'funCadastrou': funCadastrou,
        'dataAlteracao': dataAlteracao?.toIso8601String(),
        'codUsuario': codUsuario,
        'produto': produto?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CatalogoModel].
  factory CatalogoModel.fromJson(String data) {
    return CatalogoModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CatalogoModel] to a JSON string.
  String toJson() => json.encode(toMap());

  CatalogoModel copyWith({
    int? codigo,
    int? codProduto,
    double? precoVenda,
    DateTime? dataCadastro,
    int? funCadastrou,
    DateTime? dataAlteracao,
    int? codUsuario,
    ProdutoModel? produto,
  }) {
    return CatalogoModel(
      codigo: codigo ?? this.codigo,
      codProduto: codProduto ?? this.codProduto,
      precoVenda: precoVenda ?? this.precoVenda,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      funCadastrou: funCadastrou ?? this.funCadastrou,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
      codUsuario: codUsuario ?? this.codUsuario,
      produto: produto ?? this.produto,
    );
  }
}
