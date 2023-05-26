import 'package:shop_list/src/data/ItemModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<Database> _opendDB() async {
    return openDatabase(join(await getDatabasesPath(), 'shoplist_db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE item(id INTEGER PRIMARY KEY, name TEXT, amount INTEGER)",
       );
      }, version: 1
    );
  }

  static Future<void> insert(ItemModel itemModel) async {
    Database database = await _opendDB();

    database.insert('item', itemModel.toMap());
  }

  static Future<List<ItemModel>> items() async {
    Database database = await _opendDB();
    final List<Map<String,dynamic>> itemMap = await database.query('item');

    return List.generate(itemMap.length, (i) => ItemModel(
      id: itemMap[i]['id'],
      name: itemMap[i]['name'],
      amount: itemMap[i]['amount']
    ));
  }
}