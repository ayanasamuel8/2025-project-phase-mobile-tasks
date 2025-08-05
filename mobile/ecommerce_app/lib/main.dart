import 'package:flutter/material.dart';

import 'core/constants/colors.dart';
import 'features/products/presentation/pages/home_page.dart';
import 'injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-commerce App',
      theme: ThemeData(
        primarySwatch: CustomColor.primarySwatch,
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}
