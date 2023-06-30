import 'package:flutter/material.dart';
import 'package:shop_list/src/screens/principal.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/":(context) => PrincipalScreen(),
        //"/items":(context) => ItemsScreen(MyLista: null,)
      }
    );
  }
}