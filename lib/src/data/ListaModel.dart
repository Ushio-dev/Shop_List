class ListaModel {
  int? id;
  String name;

  ListaModel({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}