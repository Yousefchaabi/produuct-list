import 'package:get_it/get_it.dart';
import 'package:products_app/screens/bloc/product_bloc.dart';
import 'data/repositories/product_repository.dart';
import 'data/services/api_service.dart';

/// Instance globale de GetIt (Service Locator)
/// sl = Service Locator
final sl = GetIt.instance;

/// Fonction pour initialiser toutes les dépendances
/// À appeler dans main() avant runApp()
Future<void> initializeDependencies() async {
  // ============================================
  // 1. SERVICES (Couche Data - API)
  // ============================================
  // Singleton : Une seule instance pour toute l'app
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // ============================================
  // 2. REPOSITORIES (Couche Data - Logique)
  // ============================================
  // Singleton : Réutilise la même instance partout
  sl.registerLazySingleton<ProductRepository>(
        () => ProductRepository(sl()), // sl() récupère ApiService
  );

  // ============================================
  // 3. BLOCS (Couche Business Logic)
  // ============================================
  // Factory : Crée une nouvelle instance à chaque appel
  // Utile pour les Blocs car ils peuvent être fermés (closed)
  sl.registerFactory<ProductBloc>(
        () => ProductBloc(sl()), // sl() récupère ProductRepository
  );
}