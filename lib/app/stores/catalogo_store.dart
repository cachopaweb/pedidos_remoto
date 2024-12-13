import 'package:flutter_triple/flutter_triple.dart';
import 'package:primor/app/models/catalogo/catalogo_model.dart';
import 'package:primor/app/repositories/catalogo_repository.dart';

class CatalogoStore extends Store<List<CatalogoModel>> {
  final repository = CatalogoRepository();

  CatalogoStore() : super([]);

  Future<void> fetchCatalogo(int codUsuario) async {
    execute(() => repository.getCatalogo(codUsuario));
  }
}
