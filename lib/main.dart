import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/pages/product_list_page.dart';
import 'presentation/pages/product_form_page.dart'; 

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Productos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (_) => const ProductListPage(),
        '/add': (_) => const ProductFormPage(),
        '/edit': (_) => const ProductFormPage(), 
      },
    );
  }
}
