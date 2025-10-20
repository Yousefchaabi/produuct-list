import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

/// Bloc avec Injectable
@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;

  // Cache local
  List<Product> _allProducts = [];

  ProductBloc(this._repository) : super(const ProductState.initial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<ResetSearch>(_onResetSearch);
  }

  /// Handler : Charger les produits
  Future<void> _onLoadProducts(
      LoadProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductState.loading());

    try {
      final products = await _repository.getProducts();
      _allProducts = products;

      emit(ProductState.loaded(products: products));
    } catch (e) {
      emit(ProductState.error('Impossible de charger: $e'));
    }
  }

  /// Handler : Rechercher
  Future<void> _onSearchProducts(
      SearchProducts event,
      Emitter<ProductState> emit,
      ) async {
    if (event.query.isEmpty) {
      emit(ProductState.loaded(products: _allProducts));
      return;
    }

    emit(const ProductState.loading());

    try {
      final filteredProducts = await _repository.searchProducts(event.query);

      emit(ProductState.loaded(
        products: filteredProducts,
        isSearching: true,
      ));
    } catch (e) {
      emit(ProductState.error('Erreur de recherche: $e'));
    }
  }

  /// Handler : Réinitialiser
  Future<void> _onResetSearch(
      ResetSearch event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductState.loaded(products: _allProducts));
  }
}