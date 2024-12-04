import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pedidos_remoto/app/models/catalogo/produto_model.dart';

import '../models/itens_carrinho.dart';
import '../models/itens_pedido.dart';
import '../models/pedido_model.dart';
import '../models/usuario_logado.dart';
import '../repositories/pedido_repository.dart';
import '../services/local_storage_interface.dart';
import '../services/shared_local_storage_service.dart';

class CarrinhoController extends ChangeNotifier {
  final IPedidoRepository pedidoRepository;
  final ILocalStorage storage = SharedLocalStorageService();
  List<Item> _itens = [];

  CarrinhoController(this.pedidoRepository) {
    init();
  }

  init() async {
    final String? response = await storage.get('itens');
    if (response != null) {
      var dataJson = jsonDecode(response) as List;
      _itens = dataJson.map((e) => Item.fromMap(e)).toList();
      notifyListeners();
    }
  }

  int get totalItens => _itens.length;

  double get quantidadeItens {
    if (_itens.isNotEmpty) {
      return _itens.map((e) => e.quantidade).reduce((a, b) => a + b);
    } else {
      return 0.0;
    }
  }

  List<Item> get itens {
    return _itens;
  }

  void clean() async {
    _itens.clear();
    await storage.remove('itens');
    notifyListeners();
  }

  void incrementaQuantidade(int codigo) async {
    var index = _itens.indexWhere((element) => element.codigo == codigo);
    if (index >= 0) {
      if (index >= 0) {
        _itens[index].quantidade++;
      }
    }
    var data = jsonEncode(_itens.map((e) => e.toMap()).toList());
    await storage.put('itens', data);
    notifyListeners();
  }

  void decrementaQuantidade(int codigo) async {
    bool deleteItens = false;
    var index = _itens.indexWhere((element) => element.codigo == codigo);
    if (index >= 0) {
      _itens[index].quantidade--;
      if (_itens[index].quantidade < 0) {
        _itens[index].quantidade = 0;
      }
      deleteItens = _itens[index].quantidade == 0.0;
      if (deleteItens) {
        _itens.removeAt(index);
      }
    }
    var data = jsonEncode(_itens.map((e) => e.toMap()).toList());
    await storage.put('itens', data);
    notifyListeners();
  }

  double get valorTotal {
    if (_itens.isNotEmpty) {
      return _itens
          .map((e) => e.valor! * e.quantidade)
          .reduce((value, element) => value + element);
    } else {
      return 0.0;
    }
  }

  addItem(ProdutoModel produto) async {
    var index =
        _itens.indexWhere((element) => element.codigo == produto.codigo);
    if (index < 0) {
      var itemCarrinho = Item(
        codigo: produto.codigo!,
        quantidade: 1,
        valor: produto.valorv,
        nome: produto.nome!,
      );
      _itens.add(itemCarrinho);
    } else {
      if (index >= 0) {
        _itens[index].quantidade++;
      }
    }
    final data = jsonEncode(_itens.map((e) => e.toMap()).toList());
    await storage.put('itens', data);
    notifyListeners();
  }

  removeItem(int codigo) async {
    var index = _itens.indexWhere((element) => element.codigo == codigo);
    if (index >= 0) {
      _itens[index].quantidade--;
      if (_itens[index].quantidade < 0) {
        _itens[index].quantidade = 0;
      }
      final deleteItens = _itens[index].quantidade == 0.0;
      if (deleteItens) {
        _itens.removeAt(index);
      }
    }
    final data = jsonEncode(_itens.map((e) => e.toMap()).toList());
    await storage.put('itens', data);
    notifyListeners();
  }

  Future<bool> inserePedido(UsuarioLogado usuarioLogado) async {
    var itens = <ItensPedido>[];

    final total = valorTotal;
    var pedidoModel = PedidoModel(
      cli: 1,
      enderecoEntrega: 'TESTE',
      formasPagamento: 'DINHEIRO',
      data: DateTime.now(),
      fun: usuarioLogado.codigo,
      status: 'ENVIADO',
      valor: total,
    );

    final pedido = await pedidoRepository.inserePedido(pedidoModel);
    ////
    itens = _itens
        .map(
          (e) => ItensPedido(
            pro: e.codigo,
            nome: e.nome,
            quantidade: e.quantidade,
            ped: pedido.codigo,
            valor: e.valor! * e.quantidade,
          ),
        )
        .toList();
    return await pedidoRepository.insereItensPedido(itens);
  }
}