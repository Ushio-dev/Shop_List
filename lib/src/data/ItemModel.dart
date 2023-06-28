class ItemModel {
  int? id;
  String? name;
  int? amount;
  int? price;
  int? id_lista;

  ItemModel({this.id, this.name, this.amount, this.price, this.id_lista});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'amount': amount, 'id_lista': id_lista};
  }

  Map<String, dynamic> toMapRequest() {
    return {'name': name, 'amount': amount, 'lista_id': id_lista};
  }
}
