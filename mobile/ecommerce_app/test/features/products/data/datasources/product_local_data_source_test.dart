import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(mockSharedPreferences);
  });
  final cachedProductsJson = fixture('cached_products');
  final cachedProductsList = (List<Map<String, dynamic>>.from(
    json.decode(cachedProductsJson) as List,
  )).map((json) => ProductModel.fromJson(json)).toList();

  group('getAllCachedProducts', () {
    test(
      'should return a list of ProductModel from SharedPreferences',
      () async {
        when(
          () => mockSharedPreferences.getString(any()),
        ).thenReturn(cachedProductsJson);

        final result = await dataSource.getAllCachedProducts();
        verify(() => mockSharedPreferences.getString(cachedProducts));
        expect(result, isA<List<ProductModel>>());
        expect(result.length, cachedProductsList.length);
      },
    );
    test('should throw CacheExeption when there is no cached data', () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      final call = dataSource.getAllCachedProducts();

      expect(() => call, throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheAllProducts', () {
    final tProductModelList = cachedProductsList;
    test('should call SharedPreferences to cache the data', () async {
      final expectedJsonString = json.encode(
        tProductModelList.map((product) => product.toJson()).toList(),
      );
      // arrange
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);
      // act
      await dataSource.cacheAllProduct(cachedProductsList);
      // assert
      verify(
        () =>
            mockSharedPreferences.setString(cachedProducts, expectedJsonString),
      );
    });
  });
}
