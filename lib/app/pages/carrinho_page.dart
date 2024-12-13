import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/usuario_controller.dart';
import '../core/app_colors.dart';
import '../models/cliente_model.dart';
import '../models/tipo_pgm_model.dart';
import '../controllers/carinho_controller.dart';
import '../core/app_text_styles.dart';
import '../widgets/card_finalizar_pedido_widget.dart';
import '../widgets/item_carrinho_widget.dart';
import '../widgets/responsive_widget.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  CarrinhoPageState createState() => CarrinhoPageState();
}

class CarrinhoPageState extends State<CarrinhoPage> {
  bool isLoading = false;
  late final clienteController =
      ValueNotifier<ClienteModel>(ClienteModel.empty());
  final enderecoController = TextEditingController(text: '');
  final tipoPgmController = ValueNotifier<TipoPgmModel>(TipoPgmModel.empty());
  final emitNFController = ValueNotifier<bool>(false);
  final obsController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    clienteController.addListener(() {
      enderecoController.text = clienteController.value.endereco ?? '';
    });
  }

  _showSnackBar(String message) {
    var snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _showMessage(String message) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
            title: const Text(
              'Validação de dados',
              style: TextStyle(color: Colors.red),
            ),
            content: Text(message));
      },
    );
  }

  _finalizarPedido(CarrinhoController controller) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() {
      isLoading = true;
    });

    final usuarioLogado =
        Provider.of<UsuarioController>(context, listen: false).usuarioLogado;

    try {
      final success = await controller.inserePedido(
        usuarioLogado,
        clienteController.value,
        enderecoController.text,
        tipoPgmController.value,
        emitNFController.value,
        obsController.text,
      );
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (success) {
        controller.clean();
        navigator.pushReplacementNamed('/finalizacao');
      } else {
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
            'Erro ao finalizar pedido!',
            style: TextStyle(color: Colors.red),
          ),
        ));
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          'Erro ao finalizar pedido!\n${e.toString()}',
          style: const TextStyle(color: Colors.red),
        ),
      ));
    }
  }

  _buildItensCarrinho(CarrinhoController carrinhoController) {
    final size = MediaQuery.of(context).size;
    var itensCarrinho = carrinhoController.itens;
    double valorTotal = carrinhoController.valorTotal;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: itensCarrinho.length,
              itemBuilder: (_, index) {
                return ItemCarrinhoWidget(
                  context: context,
                  itensCarrinho: itensCarrinho,
                  index: index,
                  controller: carrinhoController,
                );
              },
            ),
          ),
          SizedBox(
            width: size.width,
            child: Center(
              child: ResponsiveWidget(
                mobile: Column(
                  children: [
                    _botaoCancelar(size, carrinhoController),
                    const SizedBox(
                      height: 5,
                    ),
                    botaoFinalizar(size, carrinhoController),
                  ],
                ),
                tablet: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _botaoCancelar(size, carrinhoController),
                    const SizedBox(
                      width: 5,
                    ),
                    botaoFinalizar(size, carrinhoController),
                  ],
                ),
              ),
            ),
          ),
          panelPrecos(valorTotal),
        ],
      ),
    );
  }

  Widget _botaoCancelar(Size size, CarrinhoController controller) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: size.width * 0.45,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(5),
          backgroundColor: WidgetStateProperty.all(Colors.red),
        ),
        child: Text(
          'Cancelar Pedido',
          style: AppTextStyles.title,
        ),
        onPressed: () async {
          try {
            final cancelar = await _showModalCancelarPedido();
            if (cancelar) {
              //limpa o carrinho
              controller.clean();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/catalogo');
              }
            }
          } catch (e) {
            var snackBar = const SnackBar(
                content: Text(
              'Erro ao cancelar pedido!',
              style: TextStyle(
                color: Colors.red,
              ),
            ));
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
    );
  }

  Container panelPrecos(double valorTotal) {
    return Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary,
        ),
        child: Center(
          child: Text(
            'R\$ ${valorTotal.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ));
  }

  Widget botaoFinalizar(Size size, CarrinhoController controller) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: size.width * 0.45,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(5),
          backgroundColor: WidgetStateProperty.all(AppColors.primary),
        ),
        child: Text(
          'Finalizar Pedido',
          style: AppTextStyles.title,
        ),
        onPressed: () async {
          try {
            final dadosPedidoSucess = await _showModalDadosPedido();
            if (dadosPedidoSucess) {
              _finalizarPedido(controller);
            }
          } catch (e) {
            var snackBar = const SnackBar(
                content: Text(
              'Erro ao finalizar pedido!',
              style: TextStyle(
                color: Colors.red,
              ),
            ));
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
    );
  }

  Future _showModalDadosPedido() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Dados para finalizar o pedido'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: CardFinalizarPedidoWidget(
                clienteController: clienteController,
                enderecoController: enderecoController,
                tipoPgmController: tipoPgmController,
                emitNFController: emitNFController,
                obsController: obsController,
              ),
            ),
          ),
          actions: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Você tem certeza que deseja finalizar o Pedido?',
                    style: AppTextStyles.textBodyBold,
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.green)),
                    onPressed: () {
                      if (clienteController.value.codigo == 0) {
                        _showMessage('Cliente não informado!');
                        return;
                      }

                      if (enderecoController.text.isEmpty) {
                        _showMessage('Endereço não informado!');
                        return;
                      }

                      if (tipoPgmController.value.descricao.isEmpty) {
                        _showMessage('Tipo Pagamento não informado!');
                        return;
                      }
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Sim', style: AppTextStyles.title),
                  ),
                  const SizedBox(width: 35),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red)),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Não', style: AppTextStyles.title),
                  ),
                ]),
              ],
            ),
          ],
        );
      },
    );
  }

  Future _showModalCancelarPedido() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Cancelar pedido'),
          actions: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Você tem certeza que deseja cancelar o Pedido?',
                    style: AppTextStyles.textBodyBold,
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.green)),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Sim', style: AppTextStyles.title),
                  ),
                  const SizedBox(width: 35),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red)),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Não', style: AppTextStyles.title),
                  ),
                ]),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final carrinhoController = Provider.of<CarrinhoController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
        actions: const [
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : carrinhoController.totalItens > 0
              ? _buildItensCarrinho(carrinhoController)
              : const SizedBox(
                  height: 1,
                ),
    );
  }
}
