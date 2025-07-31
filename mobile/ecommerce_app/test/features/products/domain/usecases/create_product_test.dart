import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/products/domain/usecases/create_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// A mock class for the [ProductRepository] using mocktail.
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  // Dependencies
  late CreateProductUsecase usecase;
  late MockProductRepository mockRepository;

  // A fallback value for mocktail in case [any<Product>()] is used
  final fallbackProduct = Product(
    id: '0',
    name: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );

  setUp(() {
    // Initialize the mock repository and the usecase before each test
    mockRepository = MockProductRepository();
    usecase = CreateProductUsecase(mockRepository);

    // Register fallback value required by mocktail for argument matchers
    registerFallbackValue(fallbackProduct);
  });

  group('CreateProductUsecase', () {
    test(
      'should call createProduct on the repository and return Right(unit) when successful',
      () async {
        // Arrange
        final product = Product(
          id: '1',
          name: 'Test Product',
          price: 10.0,
          description: 'A test product',
          imageUrl: 'http://example.com/test.jpg',
        );

        // Stub the repository to return success
        when(
          () => mockRepository.createProduct(product),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        await usecase.call(product);

        // Assert
        verify(() => mockRepository.createProduct(product)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return Left(ServerFailure) when repository fails to create product',
      () async {
        // Arrange
        final product = Product(
          id: '2',
          name: 'Invalid Product',
          price: 20.0,
          description: 'An error product',
          imageUrl: 'http://example.com/error.jpg',
        );

        final failure = const ServerFailure('Failed to create product');

        // Stub the repository to return failure
        when(
          () => mockRepository.createProduct(product),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await usecase.call(product);

        // Assert
        expect(result, equals(Left(failure)));
        verify(() => mockRepository.createProduct(product)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
