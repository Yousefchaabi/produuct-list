import 'package:injectable/injectable.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

/// Repository avec Injectable
@lazySingleton
class ProductRepository {
  final ApiService _apiService;

  /// Injection automatique d'ApiService
  ProductRepository(this._apiService);

  /// Récupérer tous les produits
  Future<List<Product>> getProducts() async {
    try {
      final response = await _apiService.getProducts();
      final List<dynamic> productsJson = response.data as List<dynamic>;

      return productsJson
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération: $e');
    }
  }

  /// Rechercher des produits
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _apiService.searchProducts(query);
      final List<dynamic> productsJson = response.data as List<dynamic>;

      final allProducts = productsJson
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      // Filtrage local
      final searchLower = query.toLowerCase();
      return allProducts.where((product) {
        return product.title.toLowerCase().contains(searchLower) ||
            product.category.toLowerCase().contains(searchLower);
      }).toList();
    } catch (e) {
      throw Exception('Erreur de recherche: $e');
    }
  }
}