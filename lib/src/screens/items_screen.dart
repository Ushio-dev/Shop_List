import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/src/data/ListaModel.dart';
import 'package:shop_list/src/providers/items_provider.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    final lista = ModalRoute.of(context)!.settings.arguments as ListaModel;
    final id = lista.id as int;
    final name = lista.name;
    context.read<ItemProvider>().fetchItems(id);

    print(context.watch<ItemProvider>().items);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Text("la lista"),
      ),
    );
  }
}