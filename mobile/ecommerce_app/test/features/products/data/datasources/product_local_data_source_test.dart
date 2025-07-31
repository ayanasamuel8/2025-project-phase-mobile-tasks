import 'dart:convert';

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

  final cachedProductsJson = fixture('cached_products');
  final cachedProductsList =
      ((json.decode(cachedProductsJson)['data'] as List<dynamic>)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList());

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(mockSharedPreferences);
  });

  void mockGetStringReturnsJson() {
    when(
      () => mockSharedPreferences.getString(any()),
    ).thenReturn(cachedProductsJson);
  }

  group('getAllCachedProducts', () {
    test(
      'should return a list of ProductModel from SharedPreferences',
      () async {
        mockGetStringReturnsJson();

        final result = await dataSource.getAllCachedProducts();

        verify(() => mockSharedPreferences.getString(cachedProducts));
        expect(result, isA<List<ProductModel>>());
        expect(result.length, cachedProductsList.length);
      },
    );

    test('should throw CacheExeption when there is no cached data', () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      expect(
        () => dataSource.getAllCachedProducts(),
        throwsA(const TypeMatcher<CacheException>()),
      );
    });
  });

  group('getCachedProductById', () {
    final tProductId = '66c775b9322c0bf78ca69c59';
    final tProductModel = cachedProductsList.firstWhere((product) {
      return product.id == tProductId;
    });

    test('should return ProductModel when the id matches', () async {
      mockGetStringReturnsJson();

      final result = await dataSource.getCachedProductById(tProductId);

      verify(() => mockSharedPreferences.getString(cachedProducts));
      expect(result, equals(tProductModel));
    });

    test('should throw CacheException when no product is found', () async {
      mockGetStringReturnsJson();

      expect(
        () => dataSource.getCachedProductById('999'),
        throwsA(const TypeMatcher<CacheException>()),
      );
    });
  });

  group('cacheAllProducts', () {
    final tProductModelList = cachedProductsList;
    test('should call SharedPreferences to cache the data', () async {
      final expectedJsonString = json.encode(
        tProductModelList.map((product) => product.toJson()).toList(),
      );
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);

      await dataSource.cacheAllProduct(cachedProductsList);

      verify(
        () =>
            mockSharedPreferences.setString(cachedProducts, expectedJsonString),
      );
    });
  });
}
