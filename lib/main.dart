import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/src/myApp.dart';
import 'package:shop_list/src/providers/items_provider.dart';
import 'package:shop_list/src/providers/listas_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ListasProvider()),
      ChangeNotifierProvider(create: (_) => ItemProvider())
    ],
    child: MyApp(),
  ));
}
