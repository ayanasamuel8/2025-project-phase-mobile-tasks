import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/colors.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/products/presentation/pages/add_page.dart';
import 'features/products/presentation/pages/details_page.dart';
import 'features/products/presentation/pages/home_page.dart';
import 'features/products/presentation/pages/update_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.sl<ProductsBloc>()..add(const LoadAllProductsEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-commerce App',
        theme: ThemeData(
          primarySwatch: CustomColor.primarySwatch,
          useMaterial3: false,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomePage(),
          '/add': (context) => const AddPage(),
          '/update': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
            return UpdatePage(
              productId: args['productId'],
              name: args['name'],
              price: args['price'],
              description: args['description'],
              imageUrl: args['imageUrl'],
            );
          },
          '/details': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
            return DetailsPage(productId: args['productId']);
          },
        },
      ),
    );
  }
}
