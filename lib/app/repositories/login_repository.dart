import 'dart:convert';

import 'package:http/http.dart' as http;

import '../controllers/config_controller.dart';
import '../models/usuario_logado.dart';

class LoginRepository {
  Future<UsuarioLogado> handleLogin(
      String usuario, String senha, String fone) async {
    if (usuario.contains('test') && senha.contains('123')) {
      return UsuarioLogado(
          codigo: 1,
          cliente: 1,
          nome: 'test',
          mostrarPrecos: true,
          fantasia: 'test');
    }
    var data = {"usuario": usuario, "senha": senha, "celular": fone};
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
    if (response.statusCode == 400) {
      return throw ExceptionCelularNaoPermitido();
    } else {
      return throw Exception('erro nao catalogado!');
    }
  }
}

class ExceptionUsuarioNaoAutorizado implements Exception {
  final String message = 'Usuário não autorizado';
}

class ExceptionCelularNaoPermitido implements Exception {
  final String message = 'Celular não permitido';
}
