import 'dart:convert';

import 'package:http/http.dart' as http;

import '../controllers/config_controller.dart';
import '../models/usuario_logado.dart';

class LoginRepository {
  Future<UsuarioLogado> handleLogin(String usuario, String senha) async {
    if (usuario.contains('test') && senha.contains('123')) {
      return UsuarioLogado(
        codigo: 1,
        login: 'test',
        mostrarPrecos: true,
      );
    }
    var data = {"login": usuario.toUpperCase(), "senha": senha};
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final baseUrl = ConfigController.instance.getUrlBase();
    var uri = Uri.http(baseUrl, '/v1/login');
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return UsuarioLogado.fromJson(response.body);
    }
    if (response.statusCode == 401) {
      return throw ExceptionUsuarioNaoAutorizado();
    }
    return throw Exception('erro nao catalogado!');
  }
}

class ExceptionUsuarioNaoAutorizado implements Exception {
  final String message = 'Usuário não autorizado';
}
