import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';
import 'package:intl/intl.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  const ProductFormPage({super.key});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  DateTime? _fechaExp;
  String? _imagenBase64;

  Product? productoExistente;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Product) {
      productoExistente = args;
      _nombreController.text = args.nombre;
      _fechaExp = args.fechaExp;
      _imagenBase64 = args.imagenBase64;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 60);
    if (picked != null) {
      final bytes = await File(picked.path).readAsBytes();
      setState(() {
        _imagenBase64 = base64Encode(bytes);
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaExp ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _fechaExp = picked;
      });
    }
  }

  void _guardar() {
    if (!_formKey.currentState!.validate() || _fechaExp == null || _imagenBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    final nuevoProducto = Product(
      id: productoExistente?.id,
      nombre: _nombreController.text.trim(),
      fechaExp: _fechaExp!,
      imagenBase64: _imagenBase64!,
    );

    if (productoExistente == null) {
      ref.read(productListProvider.notifier).addProduct(nuevoProducto);
    } else {
      ref.read(productListProvider.notifier).updateProduct(nuevoProducto);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: Text(productoExistente == null ? 'Agregar Producto' : 'Editar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del producto'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese un nombre' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(_fechaExp == null
                        ? 'Seleccione fecha de expiración'
                        : 'Fecha: ${formatter.format(_fechaExp!)}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _imagenBase64 == null
                  ? const Text('No hay imagen seleccionada')
                  : Image.memory(base64Decode(_imagenBase64!), height: 150),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tomar foto'),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save),
                label: Text(productoExistente == null ? 'Guardar' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
