import 'package:flutter/cupertino.dart';

import '../models/usuario_logado.dart';
import '../repositories/login_repository.dart';

class UsuarioController extends ChangeNotifier {
  static final UsuarioController _instance = UsuarioController._();
  late UsuarioLogado usuarioLogado;
  final repository = LoginRepository();

  UsuarioController._();

  static UsuarioController get instance {
    return _instance;
  }

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
