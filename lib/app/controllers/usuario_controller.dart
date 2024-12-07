import 'package:flutter/cupertino.dart';

import '../models/usuario_logado.dart';
import '../repositories/login_repository.dart';

class UsuarioController extends ChangeNotifier {
  late UsuarioLogado usuarioLogado;
  final repository = LoginRepository();

  Future<UsuarioLogado> logar(String usuario, String senha) async {
    try {
      usuarioLogado = await repository.handleLogin(usuario, senha);
      notifyListeners();

      return usuarioLogado;
    } catch (e) {
      throw Exception(e);
    }
  }
}
