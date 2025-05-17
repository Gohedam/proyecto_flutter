import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../../data/datasources/product_local_datasource.dart';

final productApiProvider = Provider<ProductApiService>((ref) {
  return ProductApiService();
});

final productListProvider = StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
  final api = ref.watch(productApiProvider);
  return ProductNotifier(api);
});

class ProductNotifier extends StateNotifier<List<Product>> {
  final ProductApiService _api;
  ProductNotifier(this._api) : super([]) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    final products = await _api.fetchProducts();
    state = products;
  }

  Future<void> addProduct(Product product) async {
    final success = await _api.addProduct(product);
    if (success) loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    final success = await _api.updateProduct(product);
    if (success) loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    final success = await _api.deleteProduct(id);
    if (success) loadProducts();
  }
}
