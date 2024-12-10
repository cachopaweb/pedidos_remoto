import 'dart:convert';

import 'package:http/http.dart' as http;

import '../controllers/config_controller.dart';
import '../models/cliente_model.dart';

class ClientesRepository {
  Future<List<ClienteModel>> getClientes() async {
    try {
      final baseUrl = ConfigController.instance.getUrlBase();
      var uri = Uri.https(baseUrl, '/v1/clientes');
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final response = await http.get(uri, headers: headers);
      final jsonData = jsonDecode(response.body);
      final lista = jsonData as List;
      return lista.map((e) => ClienteModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
