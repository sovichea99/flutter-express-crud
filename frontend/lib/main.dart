import 'package:flutter/material.dart';
import 'package:frontend/screens/product_list_screen.dart';
import 'package:provider/provider.dart';
import 'Providers/product_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProductProvider(),
        child: MaterialApp(
          title: 'Flutter Express CRUD',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const ProductListScreen(),
        ));
  }
}