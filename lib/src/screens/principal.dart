import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/src/providers/listas_provider.dart';

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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    onPressed: () {},
                    child: Text(
                        context.watch<ListasProvider>().listas[index].name,
                        textAlign: TextAlign.center));
              },
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
      child: Icon(Icons.add),
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
                                  child: Text("Cancelar")),
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
