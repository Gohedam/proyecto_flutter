import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/product.dart';

class ProductApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/productos_api'; 

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/listar_productos.php'));
    final data = jsonDecode(response.body) as List;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<bool> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/agregar_producto.php'),
      body: product.toJson(),
    );
    return jsonDecode(response.body)['success'] == true;
  }

  Future<bool> updateProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/actualizar_producto.php'),
      body: product.toJson(),
    );
    return jsonDecode(response.body)['success'] == true;
  }

  Future<bool> deleteProduct(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/eliminar_producto.php'),
      body: {'id': id.toString()},
    );
    return jsonDecode(response.body)['success'] == true;
  }
}
