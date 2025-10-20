import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

/// Bloc principal qui gère toute la logique métier des produits
/// Il écoute les Events et émet des States en conséquence
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;

  // Cache local pour stocker tous les produits
  List<Product> _allProducts = [];

  ProductBloc(this._repository) : super(const ProductInitial()) {
    // Enregistrer les handlers pour chaque type d'événement
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    //on<UpdateProduct>(_onUpdateProduct);
    //on<DeleteProduct>(_onDeleteProduct);
    on<ResetSearch>(_onResetSearch);
  }

  /// Handler : Charger tous les produits
  Future<void> _onLoadProducts(
      LoadProducts event,
      Emitter<ProductState> emit,
      ) async {
    // 1. Émettre un état de chargement
    emit(const ProductLoading());

    try {
      // 2. Appeler le repository pour récupérer les données
      final products = await _repository.getProducts();

      // 3. Sauvegarder dans le cache local
      _allProducts = products;

      // 4. Émettre un état de succès avec les produits
      emit(ProductLoaded(products: products));
    } catch (e) {
      // 5. En cas d'erreur, émettre un état d'erreur
      emit(ProductError('Impossible de charger les produits: ${e.toString()}'));
    }
  }

  /// Handler : Rechercher des produits
  Future<void> _onSearchProducts(
      SearchProducts event,
      Emitter<ProductState> emit,
      ) async {
    // Si la recherche est vide, réinitialiser
    if (event.query.isEmpty) {
      emit(ProductLoaded(products: _allProducts, isSearching: false));
      return;
    }

    emit(const ProductLoading());

    try {
      // Rechercher dans le repository
      final filteredProducts = await _repository.searchProducts(event.query);

      // Émettre les résultats filtrés avec le flag isSearching = true
      emit(ProductLoaded(
        products: filteredProducts,
        isSearching: true,
      ));
    } catch (e) {
      emit(ProductError('Erreur de recherche: ${e.toString()}'));
    }
  }


  /// Handler : Réinitialiser la recherche
  Future<void> _onResetSearch(
      ResetSearch event,
      Emitter<ProductState> emit,
      ) async {
    // Simplement retourner à la liste complète
    emit(ProductLoaded(products: _allProducts, isSearching: false));
  }
}
