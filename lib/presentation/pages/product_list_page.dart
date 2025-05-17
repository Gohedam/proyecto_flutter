import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productList = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navegar a pantalla de agregar producto
              Navigator.pushNamed(context, '/add');
            },
          ),
        ],
      ),
      body: productList.isEmpty
          ? const Center(child: Text('No hay productos registrados.'))
          : ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: MemoryImage(base64Decode(product.imagenBase64)),
                    ),
                    title: Text(product.nombre),
                    subtitle: Text('Expira: ${product.fechaExp.toLocal().toIso8601String().split('T').first}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'editar') {
                          Navigator.pushNamed(context, '/edit', arguments: product);
                        } else if (value == 'eliminar') {
                          ref.read(productListProvider.notifier).deleteProduct(product.id!);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'editar', child: Text('Editar')),
                        const PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
