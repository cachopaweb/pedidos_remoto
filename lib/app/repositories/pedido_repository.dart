// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pedidos_remoto/app/models/itens_pedido.dart';

import '../controllers/config_controller.dart';
import '../models/pedido_model.dart';

abstract class IPedidoRepository {
  Future<PedidoModel> inserePedido(PedidoModel pedidoModel);
  Future insereItensPedido(List<ItensPedido> itens);
}

class PedidoRepository implements IPedidoRepository {
  @override
  Future<PedidoModel> inserePedido(PedidoModel pedidoModel) async {
    try {
      final baseUrl = ConfigController.instance.getUrlBase();
      var uri = Uri.http(baseUrl, '/v1/pedidos');
      final pedido = pedidoModel.toMap();
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(pedido));
      return PedidoModel.fromMap(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future insereItensPedido(List<ItensPedido> itens) async {
    try {
      final baseUrl = ConfigController.instance.getUrlBase();
      var uri = Uri.http(baseUrl, '/v1/itensPedido');
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(itens.map((e) => e.toMap()).toList()));
      return response.statusCode == 200;
    } catch (e) {
      throw Exception(e);
    }
  }
}
