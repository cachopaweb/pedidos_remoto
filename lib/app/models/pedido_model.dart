import 'dart:convert';

import 'itens_pedido.dart';

class PedidoModel {
  int? codigo;
  String? formasPagamento;
  String? enderecoEntrega;
  int? cli;
  String? status;
  int? fun;
  String? obs;
  DateTime? data;
  double? valor;
  String? motivoRecusa;
  int? tipoPgm;
  String? emitirNF;
  List<ItensPedido>? itensPedido;

  PedidoModel({
    this.codigo,
    this.formasPagamento,
    this.enderecoEntrega,
    this.cli,
    this.status,
    this.fun,
    this.obs,
    this.data,
    this.valor,
    this.motivoRecusa,
    this.itensPedido,
    this.tipoPgm,
    this.emitirNF,
  });

  factory PedidoModel.fromMap(Map<String, dynamic> data) => PedidoModel(
        codigo: data['codigo'] as int?,
        formasPagamento: data['formas_pagamento'] as String?,
        enderecoEntrega: data['endereco_entrega'] as String?,
        cli: data['cli'] as int?,
        status: data['status'] as String?,
        fun: data['fun'] as int?,
        obs: data['obs'] as String?,
        data: DateTime.parse(data['data']) as DateTime?,
        valor: data['valor'] as double?,
        motivoRecusa: data['motivo_recusa'] as String?,
        tipoPgm: data['tipoPgm'] as int?,
        emitirNF: data['emitirNF'] as String?,
        itensPedido: (data['itensPedido'] as List<dynamic>?)
            ?.map((e) => ItensPedido.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'codigo': codigo,
        'formas_pagamento': formasPagamento,
        'endereco_entrega': enderecoEntrega,
        'cli': cli,
        'status': status,
        'fun': fun,
        'obs': obs,
        'data': data!.toIso8601String(),
        'valor': valor,
        'motivo_recusa': motivoRecusa,
        'tipoPgm': tipoPgm,
        'emitirNF': emitirNF,
        'itensPedido': itensPedido,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PedidoModel].
  factory PedidoModel.fromJson(String data) {
    return PedidoModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PedidoModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
