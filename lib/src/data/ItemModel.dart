class ItemModel {
  int? id;
  String? name;
  int? amount;
  int? price;

  ItemModel({this.id, this.name, this.amount, this.price});

  Map<String, dynamic> toMap() {
    return { 'id': id,
      'name': name,
      'amount': amount
    };
  }
}