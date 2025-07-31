import 'dart:convert';

import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  String productJson = fixture('product');

  final productMap = json.decode(productJson) as Map<String, dynamic>;

  group('ProductModel', () {
    test('fromJson returns correct ProductModel', () {
      final model = ProductModel.fromJson(productMap);

      expect(model.id, '1');
      expect(model.name, 'Product Name');
      expect(model.description, 'This is a sample product description.');
      expect(model.price, 29.99);
      expect(model.imageUrl, 'https://example.com/product-image.jpg');
    });

    test('toJson returns correct map', () {
      final model = ProductModel.fromJson(productMap);
      final jsonMap = model.toJson();

      expect(jsonMap, productMap);
    });

    test('toJson and fromJson are symmetric', () {
      final model = ProductModel.fromJson(productMap);
      final jsonMap = model.toJson();
      final modelFromJson = ProductModel.fromJson(jsonMap);

      expect(modelFromJson.id, model.id);
      expect(modelFromJson.name, model.name);
      expect(modelFromJson.description, model.description);
      expect(modelFromJson.price, model.price);
      expect(modelFromJson.imageUrl, model.imageUrl);
    });
  });
}
