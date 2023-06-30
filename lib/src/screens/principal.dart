import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/src/providers/listas_provider.dart';
import 'package:shop_list/src/screens/items_screen.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  @override
  void initState() {
    super.initState();
    var data = Provider.of<ListasProvider>(context, listen: false);
    data.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController nombreListaController = TextEditingController();

    if (context.watch<ListasProvider>().loading) {
      return Scaffold(
          floatingActionButton: MyFab(
              formKey: formKey, nombreListaController: nombreListaController),
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    } else if (context.watch<ListasProvider>().error != '') {
      return Scaffold(
          floatingActionButton: MyFab(
              formKey: formKey, nombreListaController: nombreListaController),
          body: const Center(
            child: Text("Error al traer los datos"),
          ));
    } else {
      return Scaffold(
          floatingActionButton: MyFab(
              formKey: formKey, nombreListaController: nombreListaController),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: SafeArea(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: context.read<ListasProvider>().listas.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                      ),
                      clipBehavior: Clip.hardEdge,
                      onPressed: () {
                        //Navigator.of(context).pushNamed("/items", arguments: context.read<ListasProvider>().listas[index]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemsScreen(
                                  MyLista: context
                                      .read<ListasProvider>()
                                      .listas[index]),
                            ));
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                                title: const Text(
                                    "¿Estas seguro que deseas eliminar?"),
                                content: Container(
                                  height: 95.0,
                                  child: Column(
                                    children: [
                                      Form(
                                          key: formKey,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                "Esta seguro que desea eliminar ${context.read<ListasProvider>().listas[index].name}?"),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancelar")),
                                          ElevatedButton(
                                              onPressed: () {
                                                // eliominar
                                                context
                                                    .read<ListasProvider>()
                                                    .deleteLista(index);
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Confirmar"))
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        );
                      },
                      child: Text(
                          context.read<ListasProvider>().listas[index].name,
                          textAlign: TextAlign.center));
                },
              ),
            )),
          ));
    }
  }
}

class MyFab extends StatelessWidget {
  const MyFab({
    super.key,
    required this.formKey,
    required this.nombreListaController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nombreListaController;
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
                'Nueva Lista',
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
                              controller: nombreListaController,
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
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    nombreListaController.text = "";
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancelar")),
                              ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<ListasProvider>().nuevaLista(
                                          nombreListaController.text);
                                      nombreListaController.text = "";
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
