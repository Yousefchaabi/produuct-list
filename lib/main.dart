import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/screens/bloc/product_bloc.dart';
import 'package:products_app/screens/views/products_screen.dart';
import 'injection_container.dart';

void main() async {
  // S'assurer que les bindings Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser toutes les dépendances (GetIt)
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Products App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      // BlocProvider fournit le Bloc à tout l'arbre de widgets
      home: BlocProvider(
        // Créer une nouvelle instance du Bloc via GetIt
        create: (context) => sl<ProductBloc>()..add(const LoadProducts()),
        child: const ProductsScreen(),
      ),
    );
  }
}