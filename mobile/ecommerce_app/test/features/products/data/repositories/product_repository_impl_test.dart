import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:ecommerce_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}

class MockLocalDataSource extends Mock implements ProductLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  // Helper data
  final tProductModel = ProductModel(
    id: '1',
    name: 'Test Product',
    price: 10.0,
    description: 'A test product',
    imageUrl: 'http://example.com/test.jpg',
  );
  final tProducts = <ProductModel>[tProductModel];
  final tProductEntity = const ProductParams(
    name: 'Test Product',
    price: 10.0,
    description: 'A test product',
    imageUrl: 'http://example.com/test.jpg',
  );
  const tId = '1';

  // Helper failures
  const serverFailure = ServerFailure('Failed to fetch products');
  const cacheFailure = CacheFailure('No cached data');

  // Helper fallback value
  final fallbackProductParamsModel = ProductParamsModel(
    name: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );
  final fallbackProductModel = ProductModel(
    id: '0',
    name: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );

  // Helper for online/offline setup
  void setOnline() {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  }

  void setOffline() {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('getAllProducts', () {
    test('should check if the device is online', () async {
      setOnline();
      repository.getAllProducts();
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        setOnline();
      });

      test(
        'should return remote data when call to remote data is successful',
        () async {
          when(
            () => mockRemoteDataSource.getAllProducts(),
          ).thenAnswer((_) async => tProducts);
          when(
            () => mockLocalDataSource.cacheAllProduct(tProducts),
          ).thenAnswer((_) async => true);
          final result = await repository.getAllProducts();
          verify(() => mockRemoteDataSource.getAllProducts());
          expect(result, equals(Right(tProducts)));
        },
      );

      test(
        'should cache data locally when call to remote data is successful',
        () async {
          when(
            () => mockRemoteDataSource.getAllProducts(),
          ).thenAnswer((_) async => tProducts);
          await repository.getAllProducts();
          verify(() => mockRemoteDataSource.getAllProducts());
          verify(() => mockLocalDataSource.cacheAllProduct(tProducts));
        },
      );

      test(
        'should return server error when call to remote data is unsuccessful',
        () async {
          when(
            () => mockRemoteDataSource.getAllProducts(),
          ).thenThrow(serverFailure);
          final result = await repository.getAllProducts();
          verify(() => mockRemoteDataSource.getAllProducts());
          expect(
            result,
            equals(const Left<Failure, List<ProductModel>>(serverFailure)),
          );
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        setOffline();
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(
            () => mockLocalDataSource.getAllCachedProducts(),
          ).thenAnswer((_) async => tProducts);
          final result = await repository.getAllProducts();
          verify(() => mockLocalDataSource.getAllCachedProducts());
          verifyNever(() => mockRemoteDataSource.getAllProducts());
          expect(result, equals(Right(tProducts)));
        },
      );

      test(
        'should return cache failure when the no cached data is present',
        () async {
          when(
            () => mockLocalDataSource.getAllCachedProducts(),
          ).thenThrow(cacheFailure);
          final result = await repository.getAllProducts();
          verify(() => mockLocalDataSource.getAllCachedProducts());
          verifyNever(() => mockRemoteDataSource.getAllProducts());
          expect(result, equals(const Left(CacheFailure('No cached data'))));
        },
      );
    });
  });

  group('createProduct', () {
    test('should check if the device is online', () async {
      setOnline();
      repository.createProduct(tProductEntity);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        setOnline();
        registerFallbackValue(fallbackProductParamsModel);
      });

      test('should call remoteDataSource to create product', () async {
        when(
          () => mockRemoteDataSource.createProduct(any<ProductParamsModel>()),
        ).thenAnswer((_) async => const Right(null));
        final result = await repository.createProduct(tProductEntity);
        verify(
          () => mockRemoteDataSource.createProduct(any<ProductParamsModel>()),
        );
        expect(result, equals(const Right(null)));
      });

      test('should return server failure when remote throws', () async {
        when(
          () => mockRemoteDataSource.createProduct(any()),
        ).thenThrow(Exception());
        final result = await repository.createProduct(tProductEntity);
        expect(
          result,
          equals(const Left(ServerFailure('Failed to create product'))),
        );
      });
    });

    group('device is offline', () {
      setUp(() {
        setOffline();
      });

      test('should return network failure', () async {
        final result = await repository.createProduct(tProductEntity);
        expect(
          result,
          equals(const Left(NetworkFailure('No internet connection'))),
        );
      });
    });
  });

  group('deleteProduct', () {
    test('should check if the device is online', () async {
      setOnline();
      repository.deleteProduct(tId);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        setOnline();
      });

      test('should call remoteDataSource to delete product', () async {
        when(
          () => mockRemoteDataSource.deleteProduct(any()),
        ).thenAnswer((_) async => Future.value());
        final result = await repository.deleteProduct(tId);
        verify(() => mockRemoteDataSource.deleteProduct(tId));
        expect(result, equals(const Right(null)));
      });

      test('should return server failure when remote throws', () async {
        when(
          () => mockRemoteDataSource.deleteProduct(any()),
        ).thenThrow(Exception());
        final result = await repository.deleteProduct(tId);
        expect(
          result,
          equals(const Left(ServerFailure('Failed to delete product'))),
        );
      });
    });

    group('device is offline', () {
      setUp(() {
        setOffline();
      });

      test('should return network failure', () async {
        final result = await repository.deleteProduct(tId);
        expect(
          result,
          equals(const Left(NetworkFailure('No internet connection'))),
        );
      });
    });
  });

  group('getProductById', () {
    test('should check if the device is online', () async {
      setOnline();
      repository.getProductById(tId);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        setOnline();
        registerFallbackValue(fallbackProductModel);
      });

      test(
        'should return remote data when call to remote data is successful',
        () async {
          when(
            () => mockRemoteDataSource.getProductById(any()),
          ).thenAnswer((_) async => tProductModel);

          final result = await repository.getProductById(tId);
          verify(() => mockRemoteDataSource.getProductById(tId));
          expect(result, equals(Right(tProductModel)));
        },
      );

      test('should return server failure when remote throws', () async {
        when(
          () => mockRemoteDataSource.getProductById(any()),
        ).thenThrow(Exception());
        final result = await repository.getProductById(tId);
        expect(
          result,
          equals(const Left(ServerFailure('Failed to fetch product'))),
        );
      });
    });

    group('device is offline', () {
      setUp(() {
        setOffline();
      });

      test('should return cached product when present', () async {
        when(
          () => mockLocalDataSource.getCachedProductById(any()),
        ).thenAnswer((_) async => tProductModel);
        final result = await repository.getProductById(tId);
        verify(() => mockLocalDataSource.getCachedProductById(tId));
        expect(result, equals(Right(tProductModel)));
      });

      test('should return cache failure when product not in cache', () async {
        when(
          () => mockLocalDataSource.getCachedProductById(any()),
        ).thenThrow(Exception());
        final result = await repository.getProductById(tId);
        expect(
          result,
          equals(const Left(CacheFailure('Product not found in cache'))),
        );
      });
    });
  });

  group('updateProduct', () {
    test('should check if the device is online', () async {
      setOnline();
      repository.updateProduct(tProductModel);
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        setOnline();
        registerFallbackValue(fallbackProductModel);
      });

      test(
        'should call remoteDataSource to update product and cache locally',
        () async {
          when(
            () => mockRemoteDataSource.updateProduct(any()),
          ).thenAnswer((_) async => Future.value());

          final result = await repository.updateProduct(tProductModel);
          verify(() => mockRemoteDataSource.updateProduct(any()));
          expect(result, equals(const Right(null)));
        },
      );

      test('should return server failure when remote throws', () async {
        when(
          () => mockRemoteDataSource.updateProduct(any()),
        ).thenThrow(Exception());
        final result = await repository.updateProduct(tProductModel);
        expect(
          result,
          equals(const Left(ServerFailure('Failed to update product'))),
        );
      });
    });

    group('device is offline', () {
      setUp(() {
        setOffline();
      });

      test('should return network failure', () async {
        final result = await repository.updateProduct(tProductModel);
        expect(
          result,
          equals(const Left(NetworkFailure('No internet connection'))),
        );
      });
    });
  });
}
