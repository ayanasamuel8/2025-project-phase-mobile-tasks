import 'dart:convert';

import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() async {
    mockHttpClient = MockHttpClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue(Uri.parse('https://example.com/api'));
  });

  void setUpMockHttpClientSuccess200() {
    when(
      () => mockHttpClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response(fixture('products'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(
      () => mockHttpClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response('something went wrong', 404));
  }

  final productJson = fixture('product');

  group('getAllProducts', () {
    final tProductList = (json.decode(fixture('products'))['data'] as List)
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
    test('should perform a GET request on a URL', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSource.getAllProducts();
      //assert
      verify(
        () => mockHttpClient.get(
          Uri.parse(
            'https://g5-flutter-learning-path-be.onrender.com/api/v3/products',
          ),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return product model when the response code is 200', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getAllProducts();
      //assert
      expect(result, equals(tProductList));
    });
    test(
      'should throw a server exception when the response code is 404 or other',
      () async {
        //arrange
        setUpMockHttpClientFailure404();
        //act
        final call = dataSource.getAllProducts;
        //assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  void setUpMockHttpClientSuccessId200() {
    when(
      () => mockHttpClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response(fixture('product'), 200));
  }

  group('getProductById', () {
    final tProduct = ProductModel.fromJson(
      jsonDecode(productJson)['data'] as Map<String, dynamic>,
    );
    test('should perform a GET request on a URL', () async {
      //arrange
      setUpMockHttpClientSuccessId200();
      //act
      dataSource.getProductById('1');
      //assert
      verify(
        () => mockHttpClient.get(
          Uri.parse(
            'https://g5-flutter-learning-path-be.onrender.com/api/v3/products/1',
          ),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return product model when the response code is 200', () async {
      //arrange
      setUpMockHttpClientSuccessId200();
      //act
      final result = await dataSource.getProductById('1');
      //assert
      expect(result, equals(tProduct));
    });
    test(
      'should throw a server exception when the response code is 404 or other',
      () async {
        //arrange
        setUpMockHttpClientFailure404();
        //act
        final call = dataSource.getProductById;
        //assert
        expect(() => call('1'), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('createProduct', () {
    test('should post product request on URL', () async {
      //arrange
      when(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response(productJson, 201));
      //act
      final result = await dataSource.createProduct(
        ProductModel.fromJson(
          jsonDecode(productJson)['data'] as Map<String, dynamic>,
        ),
      );
      //assert
      verify(
        () => mockHttpClient.post(
          Uri.parse(
            'https://g5-flutter-learning-path-be.onrender.com/api/v3/products',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
            ProductModel.fromJson(
              jsonDecode(productJson)['data'] as Map<String, dynamic>,
            ),
          ),
        ),
      );
      expect(result, productJson);
    });
    test('should return server exception if uncessfull', () async {
      //arrange
      when(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 400));
      //act
      final call = dataSource.createProduct;
      //assert
      expect(
        () => call(
          ProductModel.fromJson(
            jsonDecode(productJson)['data'] as Map<String, dynamic>,
          ),
        ),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });
  });

  group('deleteProduct', () {
    test('should perform a DELETE request on a URL', () async {
      //arrange
      when(
        () => mockHttpClient.delete(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('', 204));
      //act
      await dataSource.deleteProduct('1');
      //assert
      verify(
        () => mockHttpClient.delete(
          Uri.parse(
            'https://g5-flutter-learning-path-be.onrender.com/api/v3/products/1',
          ),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test(
      'should throw a server exception when the response code is not 204',
      () async {
        //arrange
        when(
          () => mockHttpClient.delete(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('Error', 404));
        //act
        final call = dataSource.deleteProduct;
        //assert
        expect(() => call('1'), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('updateProduct', () {
    test('should perform a PUT request on a URL', () async {
      //arrange
      when(
        () => mockHttpClient.put(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response(productJson, 200));
      //act
      await dataSource.updateProduct(
        ProductModel.fromJson(
          jsonDecode(productJson)['data'] as Map<String, dynamic>,
        ),
      );
      //assert
      verify(
        () => mockHttpClient.put(
          Uri.parse(
            'https://g5-flutter-learning-path-be.onrender.com/api/v3/products/${ProductModel.fromJson(jsonDecode(productJson)['data'] as Map<String, dynamic>).id}',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
            ProductModel.fromJson(
              jsonDecode(productJson)['data'] as Map<String, dynamic>,
            ),
          ),
        ),
      );
    });

    test('should return server exception if unsuccessful', () async {
      //arrange
      when(
        () => mockHttpClient.put(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 400));
      //act
      final call = dataSource.updateProduct;
      //assert
      expect(
        () => call(
          ProductModel.fromJson(
            jsonDecode(productJson)['data'] as Map<String, dynamic>,
          ),
        ),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });
  });
}
