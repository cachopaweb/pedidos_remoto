import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/usuario_controller.dart';
import '../core/core.dart';
import '../services/local_storage_interface.dart';
import '../services/shared_local_storage_service.dart';
import '../widgets/logo_widget.dart';
import '../widgets/myinput_text.dart';

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final ILocalStorage localStorage = SharedLocalStorageService();
  final txtUsuarioController = TextEditingController(text: '');
  final txtSenhaController = TextEditingController(text: '');
  final String version = '1.0.0';
  var tentandoLogar = false;

  _setarInputs() async {
    var usuario = await localStorage.get('usuario') ?? '';
    var senha = await localStorage.get('senha') ?? '';
    setState(() {
      txtUsuarioController.text = usuario;
      txtSenhaController.text = senha;
    });
  }

  @override
  void initState() {
    super.initState();
    _setarInputs();
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  _showSnackBar(String message) {
    var snackBar = SnackBar(
      content: Text(
        message != ''
            ? message
            : 'Usuário ou Senha incorretos\nou número de celular não permitido!',
        style: const TextStyle(color: Colors.white),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _tryLogin(UsuarioController controller) async {
    // Store context reference before async operations
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      setState(() {
        tentandoLogar = true;
      });
      if (txtUsuarioController.text.isEmpty) {
        throw ValidationException("Preencha o campo Usuário!");
      }
      if (txtSenhaController.text.isEmpty) {
        throw ValidationException("Preencha o campo Senha!");
      }
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text("Aguarde, logando no servidor...")));

      final usuario = await controller.logar(
        txtUsuarioController.text,
        txtSenhaController.text,
      );

      if (!mounted) return; // Guard against widget being disposed

      setState(() {
        tentandoLogar = false;
      });

      if (usuario.codigo > 0) {
        localStorage.put("usuario", txtUsuarioController.text);
        localStorage.put("senha", txtSenhaController.text);
        navigator.pushReplacementNamed('/catalogo');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        tentandoLogar = false;
      });

      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(e is Exception ? e.toString() : 'Erro ao fazer login'),
      ));
    }
  }

  _botaoLogar(UsuarioController usuarioController, Size size) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      height: 50,
      width: size.width,
      child: TextButton(
        child: !tentandoLogar
            ? Text(
                'Logar',
                style: AppTextStyles.title,
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Logando...',
                    style: AppTextStyles.title,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      backgroundColor: AppColors.secondary,
                    ),
                  )
                ],
              ),
        onPressed: () async {
          try {
            _tryLogin(usuarioController);
          } catch (e) {
            _showSnackBar(e.toString());
          }
        },
      ),
    );
  }

  _telaLogin(UsuarioController usuarioController, Size size) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyInputText(
            label: 'Usuário',
            icone: const Icon(Icons.person),
            inputSenha: false,
            controller: txtUsuarioController,
          ),
          const SizedBox(height: 5),
          MyInputText(
            label: 'Senha',
            icone: const Icon(Icons.lock),
            inputSenha: true,
            controller: txtSenhaController,
          ),
          _botaoLogar(usuarioController, size),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Versão: $version', style: AppTextStyles.textBodyBold),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: SizedBox(
                width: 500,
                height: 500,
                child: Column(
                  children: [
                    const LogoWidget(),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: _telaLogin(UsuarioController.instance, size),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
