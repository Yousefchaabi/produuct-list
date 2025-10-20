part of 'product_bloc.dart';

/// Classe abstraite représentant tous les états possibles de l'application
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// État initial : Rien n'a encore été chargé
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// État de chargement : Une requête est en cours
/// Affiche généralement un loader/spinner
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// État de succès : Les produits ont été chargés avec succès
class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool isSearching; // Indique si on est en mode recherche

  const ProductLoaded({
    required this.products,
    this.isSearching = false,
  });

  @override
  List<Object?> get props => [products, isSearching];

  /// Méthode utile pour créer une copie avec modifications
  ProductLoaded copyWith({
    List<Product>? products,
    bool? isSearching,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

/// État d'erreur : Une erreur s'est produite
class ProductError extends ProductState {
  final String message; // Message d'erreur à afficher

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

