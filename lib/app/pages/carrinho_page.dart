import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/usuario_controller.dart';
import '../core/app_colors.dart';
import '../widgets/botao_widget.dart';
import '../Widgets/star_icon_widget.dart';
import '../controllers/carinho_controller.dart';
import '../core/app_text_styles.dart';
import '../models/itens_carrinho.dart';
import '../widgets/card_item_widget.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  CarrinhoPageState createState() => CarrinhoPageState();
}

class CarrinhoPageState extends State<CarrinhoPage> {
  bool isLoading = false;

  _showModalFinalizar() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Fim do Pedido'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Você tem certeza que deseja finalizar o Pedido?',
                style: AppTextStyles.textBodyBold,
              ),
            ),
            actions: [
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
          );
        });
  }

  _finalizarPedido(CarrinhoController controller) {
    setState(() {
      isLoading = true;
    });
    final usuarioLogado =
        Provider.of<UsuarioController>(context, listen: false).usuarioLogado;
    controller.inserePedido(usuarioLogado).then((value) {
      if (value) {
        setState(() {
          isLoading = false;
        });
        controller.clean();
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/finalizacao');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          var snackBar = const SnackBar(
              content: Text(
            'Erro ao finalizar pedido!',
            style: TextStyle(
              color: Colors.red,
            ),
          ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        var snackBar = SnackBar(
            content: Text(
          'Erro ao finalizar pedido!\n${e.toString()}',
          style: const TextStyle(
            color: Colors.red,
          ),
        ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  _buildItensCarrinho(CarrinhoController carrinhoController) {
    final size = MediaQuery.of(context).size;
    final mostrarPrecos =
        context.watch<UsuarioController>().usuarioLogado.mostrarPrecos;
    var itensCarrinho = carrinhoController.itens;
    double valorTotal = carrinhoController.valorTotal;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: itensCarrinho.length,
            itemBuilder: (_, index) {
              return itemCarrinho(itensCarrinho, index, carrinhoController);
            },
          ),
        ),
        botaoFinalizar(size, carrinhoController),
        mostrarPrecos
            ? panelPrecos(valorTotal)
            : const SizedBox(
                height: 1,
              )
      ],
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

  Container botaoFinalizar(Size size, CarrinhoController controller) {
    return Container(
      margin: const EdgeInsets.all(35),
      height: 50,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(5),
          backgroundColor: WidgetStateProperty.all(Colors.black),
        ),
        child: Text(
          'Finalizar Pedido',
          style: AppTextStyles.title,
        ),
        onPressed: () {
          _showModalFinalizar()
              .then((value) => {
                    if (value)
                      {
                        _finalizarPedido(controller),
                      }
                  })
              .catchError((e) => {
                    log(e.toString()),
                  });
        },
      ),
    );
  }

  Widget itemCarrinho(
      List<Item> itensCarrinho, int index, CarrinhoController controller) {
    final item = itensCarrinho[index];
    return SizedBox(
      height: 100,
      child: CardItem(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.nome,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  Row(
                    children: [
                      Provider.of<UsuarioController>(context)
                              .usuarioLogado
                              .mostrarPrecos
                          ? Row(
                              children: [
                                Text(
                                  'Vlr Unit: R\$ ${item.valor!.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  'Vlr Total: R\$ ${(item.valor! * item.quantidade).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(
                              height: 1,
                            ),
                    ],
                  ),
                ],
              ),
              Acoes(item: item),
            ],
          ),
        ),
      ),
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

class Acoes extends StatelessWidget {
  const Acoes({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
    final carrinhoController =
        Provider.of<CarrinhoController>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Botao(
            size: const Size(35, 35),
            cor: Colors.red,
            icone: Icons.remove,
            onClick: () {
              carrinhoController.decrementaQuantidade(item.codigo);
            }),
        const SizedBox(width: 10),
        Text(
          item.quantidade.toStringAsFixed(0),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Botao(
          size: const Size(35, 35),
          cor: Colors.green,
          icone: Icons.add,
          onClick: () {
            carrinhoController.incrementaQuantidade(item.codigo);
          },
        ),
      ],
    );
  }
}
