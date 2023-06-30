import 'package:flutter/material.dart';
import 'package:shop_list/src/data/ItemModel.dart';
import 'package:shop_list/src/data/db.dart';

class ItemProvider with ChangeNotifier {
  List<ItemModel> _items = [];
  bool _loading = true;
  String _error = '';
  double _total = 0;

  get items => _items;
  get loading => _loading;
  get error => _error;
  get total => _total;

  Future<void> fetchItems(int id) async {
    _loading = true;
    _error = '';
    _total = 0;
    try {
      _items = await DB.traerItems(id);
      calcularTotal();
      notifyListeners();
    } catch (error) {
      _error = 'No se pudo cargar los items';
    }
  }

  Future<void> calcularTotal() async {
    _items.forEach((element) =>
        _total += (element.price as double) * (element.amount as int));
  }

  Future<void> reiniciarTotal() async {
    _total = 0;
  }

  void nuevoItem(ItemModel item) async {
    item = await DB.insertItem(item);
    await fetchItems(item.id_lista as int);
  }

  void deleteItem(int index) async {
    int id = _items[index].id as int;
    await DB.deleteItem(id);

    _total -= (_items[index].price as double) * (_items[index].amount as int);
    _items.removeAt(index);

    if (_total <= 0) {
      _total = 0;
    }
    notifyListeners();
  }

  void updateItem(ItemModel item, int index) async {
    _total -= (_items[index].price as double) * (_items[index].amount as int);
    if (_total <= 0) {
      _total = 0;
    }
    await DB.updateItem(item);
    _total = _total + ((item.price as double) * (item.amount as int));

    _items[index] = item;
    notifyListeners();
  }

  void close() {
    _items.clear();
    _total = 0;
  }
}
