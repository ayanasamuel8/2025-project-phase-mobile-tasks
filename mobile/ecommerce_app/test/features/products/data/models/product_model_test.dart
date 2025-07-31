import 'dart:convert';

import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  String productJson = fixture('product');

  final productMap = json.decode(productJson)['data'] as Map<String, dynamic>;
  productMap.remove('seller'); // Remove seller as it's not in the model

  group('ProductModel', () {
    test('fromJson returns correct ProductModel', () {
      final model = ProductModel.fromJson(productMap);

      expect(model.id, productMap['id']);
      expect(model.name, productMap['name']);
      expect(model.description, productMap['description']);
      expect(model.price, productMap['price']);
      expect(model.imageUrl, productMap['imageUrl']);
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

      expect(modelFromJson, model);
    });
  });
}
