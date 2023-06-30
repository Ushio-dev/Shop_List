import 'package:shop_list/src/data/ItemModel.dart';
import 'package:shop_list/src/data/ListaModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<void> createTableItem(Database db) async {
    await db.execute(
        "CREATE TABLE item(Item_Id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, amount INTEGER, price REAL, Lista_Id INTEGER NOT NULL, FOREIGN KEY(Lista_Id) REFERENCES listas(Lista_Id))");
  }

  static Future<void> createTableListas(Database db) async {
    await db.execute(
        "CREATE TABLE listas (Lista_Id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)");
  }

  static Future<Database> _opendDB() async {
    return openDatabase(join(await getDatabasesPath(), 'shoplist_db'),
        onCreate: (db, version) async {
      await createTableListas(db);
      await createTableItem(db);
    }, version: 1);
  }

  static Future<List<ListaModel>> traerListas() async {
    Database db = await _opendDB();
    final List<Map<String, dynamic>> listas = await db.query('listas');

    return List.generate(
        listas.length,
        (index) => ListaModel(
            id: listas[index]['Lista_Id'], name: listas[index]['name']));
  }

  static Future<List<ItemModel>> traerItems(int id) async {
    Database db = await _opendDB();
    final List<Map<String, dynamic>> items =
        await db.query('item', where: "lista_id = ?", whereArgs: [id]);

    return List.generate(
        items.length,
        (index) => ItemModel(
            id: items[index]['Item_Id'],
            name: items[index]['name'],
            amount: items[index]['amount'],
            price: items[index]['price'],
            id_lista: items[index]['Lista_Id']));
  }

  static Future<void> insertLista(String nombreLista) async {
    final db = await DB._opendDB();
    final lista = {'name': nombreLista};
    final id = await db.insert("listas", lista);
  }

  static Future<void> deleteList(int id) async {
    Database db = await _opendDB();
    await db.delete('item', where: 'lista_id = ?', whereArgs: [id]);
    await db.delete('listas', where: "lista_id = ?", whereArgs: [id]);
  }

  static Future<ItemModel> insertItem(ItemModel itemModel) async {
    Database database = await _opendDB();
    int id = await database.insert('item', itemModel.toMapRequest());
    itemModel.id = id;
    return itemModel; 
  }

  static Future<void> updateItem(ItemModel itemModel) async {
    Database db = await _opendDB();
    await db.rawUpdate("UPDATE item SET name = ?, amount = ?, price = ? WHERE item_id = ?", [itemModel.name, itemModel.amount, itemModel.price, itemModel.id]);

  }
  static Future<void> deleteItem(int id) async {
    Database db = await _opendDB();

    await db.delete('item', where: "item_id = ?", whereArgs: [id]);
  }

  // ----------------- a partir de aca no se hace una wea -----------------------------
  static Future<void> insert(ItemModel itemModel) async {
    Database database = await _opendDB();

    database.insert('item', itemModel.toMap());
  }

  static Future<List<ItemModel>> items() async {
    Database database = await _opendDB();
    final List<Map<String, dynamic>> itemMap = await database.query('item');

    return List.generate(
        itemMap.length,
        (i) => ItemModel(
            id: itemMap[i]['id'],
            name: itemMap[i]['name'],
            amount: itemMap[i]['amount'],
            id_lista: itemMap[i]['id_lista'],
            price: itemMap[i]['price']));
  }

  static Future<void> deleteAll() async {
    Database database = await _opendDB();

    database.execute("DROP TABLE listas;");
    database.execute("DROP TABLE item;");
  }
}
