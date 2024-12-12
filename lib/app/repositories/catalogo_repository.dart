import 'dart:convert';

import 'package:http/http.dart' as http;

import '../controllers/config_controller.dart';
import '../models/catalogo/catalogo_model.dart';

class CatalogoRepository {
  Future<List<CatalogoModel>> getCatalogo(int codUsuario) async {
    try {
      final baseUrl = ConfigController.instance.getUrlBase();
      var uri = Uri.http(baseUrl, '/v1/catalogo/usuario/$codUsuario');
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final response = await http.get(uri, headers: headers);
      final jsonData = jsonDecode(response.body);
      final lista = jsonData as List;
      return lista.map((e) => CatalogoModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
