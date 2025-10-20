import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/screens/views/widgets/product_card.dart';
import '../../data/models/product_model.dart';
import '../bloc/product_bloc.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Contrôleur pour la barre de recherche
  final TextEditingController _searchController = TextEditingController();

  // Indique si on est en mode recherche
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : const Text('Produits'),
        actions: [
          // Bouton pour activer/désactiver la recherche
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  // Réinitialiser la recherche
                  context.read<ProductBloc>().add(const ResetSearch());
                }
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        // Listener : Pour les actions ponctuelles (messages uniquement pour les erreurs)
        listener: (context, state) {
          if (state is ProductError) {
            // Afficher un SnackBar en cas d'erreur
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        // Builder : Pour construire l'UI en fonction de l'état
        builder: (context, state) {
          // État de chargement
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // État avec produits chargés
          if (state is ProductLoaded) {
            if (state.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.isSearching
                          ? 'Aucun résultat trouvé'
                          : 'Aucun produit disponible',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              // Pull-to-refresh pour recharger les produits
              onRefresh: () async {
                context.read<ProductBloc>().add(const LoadProducts());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductCard(
                    product: product,
                    // Boutons désactivés temporairement (fonctionnalités à venir)
                    onEdit: () => _showComingSoonMessage(context, 'Modification'),
                    onDelete: () => _showComingSoonMessage(context, 'Suppression'),
                  );
                },
              ),
            );
          }

          // État initial ou autre
          return const Center(
            child: Text('Bienvenue ! Chargez les produits.'),
          );
        },
      ),
    );
  }

  /// Widget : Barre de recherche dans l'AppBar
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(
        hintText: 'Rechercher un produit...',
        hintStyle: TextStyle(color: Colors.black12),
        border: InputBorder.none,
      ),
      onChanged: (query) {
        // Déclencher la recherche à chaque changement
        if (query.isNotEmpty) {
          context.read<ProductBloc>().add(SearchProducts(query));
        } else {
          context.read<ProductBloc>().add(const ResetSearch());
        }
      },
    );
  }

  /// Message pour les fonctionnalités à venir
  void _showComingSoonMessage(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature à venir prochainement...'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}