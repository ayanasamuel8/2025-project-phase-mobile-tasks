import 'package:basic_ecommerce/views/pages/add_page.dart';
import 'package:basic_ecommerce/views/pages/update_page.dart';
import 'package:flutter/material.dart';
import 'views/pages/home_page.dart';
import 'views/pages/details_page.dart';
import 'views/pages/search_page.dart';
import 'package:basic_ecommerce/utils/animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Basic Ecommerce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
      ),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomePage());
          case '/details':
            final args = settings.arguments as Map<String, dynamic>;
            return Animate.createFadeRoute(
              DetailsPage(product: args['product']),
            );
          case '/search':
            return Animate.createFadeRoute(const SearchPage());
          case '/add':
            return Animate.createSlideUpRoute(const AddPage());
          case '/update':
            final args = settings.arguments as Map<String, dynamic>;
            return Animate.createSlideUpRoute(
              UpdatePage(product: args['product']),
            );
          default:
            return null;
        }
      },
    );
  }
}
