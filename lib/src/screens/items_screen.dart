import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/src/data/ItemModel.dart';
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

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController nombreItemController = TextEditingController();
    TextEditingController cantidadController = TextEditingController();
    TextEditingController precioController = TextEditingController();
    //print(context.watch<ItemProvider>().items);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      floatingActionButton: MyFab(
        formKey: formKey,
        nombreItemController: nombreItemController,
        cantidadController: cantidadController,
        precioController: precioController,
        idLista: id,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: context.watch<ItemProvider>().items.length,
          itemBuilder: (context, index) {
            return Text("${context.watch<ItemProvider>().items[index].name}");
          },)
      ),
    );
  }
}

class MyFab extends StatelessWidget {
  const MyFab(
      {super.key,
      required this.formKey,
      required this.nombreItemController,
      required this.cantidadController,
      required this.precioController,
      required this.idLista});

  final GlobalKey<FormState> formKey;
  final TextEditingController nombreItemController;
  final TextEditingController cantidadController;
  final TextEditingController precioController;

  final int idLista;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: const Text(
                'Nueva Producto',
                textAlign: TextAlign.center,
              ),
              content: Stack(
                clipBehavior: Clip.none,
                children: [
                  Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              autofocus: true,
                              controller: nombreItemController,
                              decoration: const InputDecoration(
                                labelText: "Nombre",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Campo requerido";
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: cantidadController,
                              decoration:
                                  const InputDecoration(labelText: "Cantidad"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: precioController,
                              decoration: const InputDecoration(
                                  labelText: "Precio Unidad"),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    nombreItemController.text = "";
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancelar")),
                              ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      String name = nombreItemController.text;
                                      int cantidad = cantidadController.text.isNotEmpty ? int.parse(cantidadController.text) : 0;
                                      int precio = precioController.text.isNotEmpty ? int.parse(precioController.text) : 0;

                                      ItemModel nuevoItem = ItemModel(name: name, amount: cantidad, price: precio, id_lista: idLista);
                                      context.read<ItemProvider>().nuevoItem(nuevoItem);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Agregar")),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            );
          },
        );
      },
    );
  }
}
