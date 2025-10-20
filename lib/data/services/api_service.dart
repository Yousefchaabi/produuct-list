import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Service API avec Dio et Injectable
@lazySingleton // Singleton paresseux
class ApiService {
  final Dio _dio;

  static const String baseUrl = 'https://fakestoreapi.com';

  ApiService()
      : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  ) {
    // Intercepteur pour le logging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('🌐 API: $obj'),
      ),
    );
  }

  /// GET : Récupérer tous les produits
  Future<Response> getProducts() async {
    try {
      return await _dio.get('/products');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// GET : Rechercher des produits
  Future<Response> searchProducts(String query) async {
    try {
      return await _dio.get('/products');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Gestion centralisée des erreurs
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Délai de connexion dépassé';
      case DioExceptionType.sendTimeout:
        return "Délai d'envoi dépassé";
      case DioExceptionType.receiveTimeout:
        return 'Délai de réception dépassé';
      case DioExceptionType.badResponse:
        return 'Erreur serveur: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Requête annulée';
      case DioExceptionType.connectionError:
        return 'Pas de connexion internet';
      default:
        return 'Erreur inconnue: ${error.message}';
    }
  }
}