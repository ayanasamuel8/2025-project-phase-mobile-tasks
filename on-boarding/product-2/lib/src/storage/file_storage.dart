import '../models/product.dart';
import 'dart:convert';
import 'dart:io';

class FileStorage {
  final String filePath = '../data/products.json';

  List<Product> loadProducts() {
    final file = File(filePath);
    if (!file.existsSync()) {
      return [];
    }
    try {
      final json = file.readAsStringSync();
      return (jsonDecode(json) as List)
          .map((productJson) => Product.fromJson(productJson))
          .toList();
    } catch (e) {
      print('Error reading products: $e');
      return [];
    }
  }

  bool saveProducts(List<Product> products) {
    final file = File(filePath);
    file.writeAsStringSync(
      JsonEncoder.withIndent(
        '  ',
      ).convert(products.map((productJson) => productJson.toJson()).toList()),
    );

    return file.existsSync();
  }
}
