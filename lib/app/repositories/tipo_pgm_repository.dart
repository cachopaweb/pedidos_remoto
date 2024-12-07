import 'dart:convert';

import 'package:http/http.dart' as http;

import '../controllers/config_controller.dart';
import '../models/tipo_pgm_model.dart';

class TipoPgmRepository {
  Future<List<TipoPgmModel>> getTipoPgms() async {
    try {
      final baseUrl = ConfigController.instance.getUrlBase();
      var uri = Uri.http(baseUrl, '/v1/tipoPgm');
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final response = await http.get(uri, headers: headers);
      final jsonData = jsonDecode(response.body);
      final lista = jsonData as List;
      return lista.map((e) => TipoPgmModel.fromMap(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
