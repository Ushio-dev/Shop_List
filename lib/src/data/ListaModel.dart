class ListaModel {
  int? id;
  String name;
  int? total = 0;

  ListaModel({this.id, required this.name, this.total});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}