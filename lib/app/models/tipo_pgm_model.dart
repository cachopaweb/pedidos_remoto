import 'dart:convert';

class TipoPgmModel {
  int codigo;
  String descricao;
  int? con;
  String? tipo;
  String nome;
  String? titulo;
  String? condicao;
  int? diasPrazoRec;
  int? txOperacao;
  int? txAntecipacao;
  int? subDes;
  String? analisar;

  TipoPgmModel({
    required this.codigo,
    required this.descricao,
    this.con,
    this.tipo,
    required this.nome,
    this.titulo,
    this.condicao,
    this.diasPrazoRec,
    this.txOperacao,
    this.txAntecipacao,
    this.subDes,
    this.analisar,
  });

  factory TipoPgmModel.fromMap(Map<String, dynamic> data) => TipoPgmModel(
        codigo: data['codigo'] as int,
        descricao: data['descricao'] as String,
        con: data['con'] as int?,
        tipo: data['tipo'] as String?,
        nome: data['nome'] as String,
        titulo: data['titulo'] as String?,
        condicao: data['condicao'] as String?,
        diasPrazoRec: data['dias_prazo_rec'] as int?,
        txOperacao: data['tx_operacao'] as int?,
        txAntecipacao: data['tx_antecipacao'] as int?,
        subDes: data['sub_des'] as int?,
        analisar: data['analisar'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'codigo': codigo,
        'descricao': descricao,
        'con': con,
        'tipo': tipo,
        'nome': nome,
        'titulo': titulo,
        'condicao': condicao,
        'dias_prazo_rec': diasPrazoRec,
        'tx_operacao': txOperacao,
        'tx_antecipacao': txAntecipacao,
        'sub_des': subDes,
        'analisar': analisar,
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
        descricao: '',
        con: 0,
        tipo: '',
        nome: '',
        titulo: '',
        condicao: '',
        diasPrazoRec: 0,
        txOperacao: 0,
        txAntecipacao: 0,
        subDes: 0,
        analisar: '',
      );
}
