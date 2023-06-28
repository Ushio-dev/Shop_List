import 'package:flutter/foundation.dart';
import 'package:shop_list/src/data/ListaModel.dart';

import '../data/db.dart';

class ListasProvider with ChangeNotifier {
  List<ListaModel> _listas = [];
  bool _isloading = true;
  String _error = '';

  get loading => _isloading;
  get error => _error;
  get listas => _listas;

  Future<void> fetchData() async {
    _isloading = true;
    _error = '';

    try {
      _listas = await DB.traerListas();
      _isloading = false;
      notifyListeners();
    } catch (error) {
      _error = 'Error al cargar listas';
    }
  }

  void nuevaLista(String nameLista) async {
    await DB.insertLista(nameLista);
    await fetchData();
  }

  void deleteAll() async {
    await DB.deleteAll();
    fetchData();
  }
}
