import 'package:basic_ecommerce/views/pages/add_page.dart';
import 'package:flutter/material.dart';
import 'views/pages/home_page.dart';
import 'views/pages/details_page.dart';
import 'views/pages/search_page.dart';

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
      routes: {
        '/home': (context) => const HomePage(),
        '/details': (context) => DetailsPage(),
        '/search': (context) => const SearchPage(),
        '/add': (context) => const AddPage(),
      },
    );
  }
}
