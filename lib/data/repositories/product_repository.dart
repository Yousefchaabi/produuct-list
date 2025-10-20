import 'package:products_app/data/models/product_model.dart';
import 'package:products_app/data/services/api_service.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  /// Récupérer tous les produits
  Future<List<Product>> getProducts() async {
    try {
      final response = await _apiService.getProducts();

      // Convertir la liste JSON en liste d'objets Product
      final List<dynamic> productsJson = response.data as List<dynamic>;
      return productsJson
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des produits: $e');
    }
  }


  /// Rechercher des produits par nom ou catégorie
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _apiService.searchProducts(query);
      final List<dynamic> productsJson = response.data as List<dynamic>;

      // Filtrage côté client car FakeStore API ne supporte pas la recherche
      final allProducts = productsJson
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      // Recherche insensible à la casse dans le titre et la catégorie
      final searchLower = query.toLowerCase();
      return allProducts.where((product) {
        return product.title.toLowerCase().contains(searchLower) ||
            product.category.toLowerCase().contains(searchLower);
      }).toList();
    } catch (e) {
      throw Exception('Erreur lors de la recherche: $e');
    }
  }
}