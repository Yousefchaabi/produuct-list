import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/screens/bloc/product_bloc.dart';
import 'package:products_app/screens/bloc/product_event.dart';
import 'package:products_app/screens/views/products_screen.dart';
import 'core/injection/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration Injectable
  await configureDependencies();

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
      ),
      home: BlocProvider(
        create: (context) => getIt<ProductBloc>()
          ..add(const ProductEvent.loadProducts()),
        child: const ProductsScreen(),
      ),
    );
  }
}