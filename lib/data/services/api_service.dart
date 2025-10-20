import 'package:dio/dio.dart';

/// Service API utilisant Dio pour gérer toutes les requêtes HTTP

class ApiService {
  // Instance unique de Dio configurée pour notre API
  final Dio _dio;

  // URL de base de l'API FakeStore
  static const String baseUrl = 'https://fakestoreapi.com';

  ApiService() : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5), // Timeout pour la connexion
      receiveTimeout: const Duration(seconds: 3),    // Timeout pour recevoir les données
      headers: {
        'Content-Type' : 'application/json',
        'Accept' : 'application/json'
      },
    ),
  ) {
    // Intercepteur pour logger les requêtes et réponses (utile pour le debug)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );
  }

  /// Get : Récupérer tous les produits
  Future<Response> getProducts() async {
    try {
      final response = await _dio.get('/products');
      return response;
    } on DioException catch(e) {
      throw _handleError(e);
    }
  }

  /// GET : Rechercher des produits (simulation avec filtrage local)
  /// Note: FakeStore API ne supporte pas la recherche native
  Future<Response> searchProducts(String query) async {
    try {
      // On récupère tous les produits puis on filtre côté client
      final response = await _dio.get('/products');
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Gestion centralisée des erreurs Dio
  String _handleError(DioException error) {
    String errorMessage = '';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Délai de connexion dépassé';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Délai d'envoi dépassé";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Délai de réception dépassé';
        break;
      case DioExceptionType.badResponse:
        errorMessage = 'Erreur serveur: ${error.response?.statusCode}';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Requête annulée';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Pas de connexion internet';
        break;
      default:
        errorMessage = 'Erreur inconnue';
    }

    return errorMessage;
  }
  /// Getter pour accéder à l'instance Dio si nécessaire
  Dio get dio => _dio;
}

