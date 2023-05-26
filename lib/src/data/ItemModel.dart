class ItemModel {
  int? id;
  String? name;
  int? amount;

  ItemModel({this.id, this.name, this.amount});

  Map<String, dynamic> toMap() {
    return { 'id': id,
      'name': name,
      'amount': amount
    };
  }
}