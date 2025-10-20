part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Événement : Charger tous les produits
/// Déclenché au démarrage de l'app ou lors d'un refresh
class LoadProducts extends ProductEvent {
  const LoadProducts();
}

/// Événement : Rechercher des produits
/// Contient la requête de recherche (query)
class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}


/// Événement : Réinitialiser la recherche
/// Retourne à la liste complète des produits
class ResetSearch extends ProductEvent {
  const ResetSearch();
}


