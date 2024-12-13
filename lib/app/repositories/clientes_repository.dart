import 'dart:convert';

import 'package:http/http.dart' as http;

import '../controllers/config_controller.dart';
import '../models/cliente_model.dart';

class ClientesRepository {
  Future<List<ClienteModel>> getClientes(String busca) async {
    try {
      final baseUrl = ConfigController.instance.getUrlBase();
      var uri = Uri.parse('$baseUrl/clientes');
      if (busca.isNotEmpty) {
        uri = Uri.parse('$baseUrl/clientes?busca=${busca.toUpperCase()}');
      }
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
