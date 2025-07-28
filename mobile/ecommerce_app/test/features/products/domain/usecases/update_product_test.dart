import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/products/domain/usecases/update_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// A mock implementation of the ProductRepository using mocktail.
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late UpdateProductUsecase usecase;
  late MockProductRepository mockRepository;

  Product testProduct = Product(
    id: 1,
    name: 'Test Product',
    price: 10.0,
    description: 'Test product description',
    imageUrl: 'http://example.com/image.jpg',
  );

  setUp(() {
    mockRepository = MockProductRepository();
    usecase = UpdateProductUsecase(mockRepository);

    // Register a fallback Product value for mocktail.
    registerFallbackValue(
      Product(id: 0, name: '', price: 0.0, description: '', imageUrl: ''),
    );
  });

  group('UpdateProductUsecase', () {
    test(
      'should call updateProduct on repository with correct Product entity',
      () async {
        // Arrange
        when(
          () => mockRepository.updateProduct(testProduct),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await usecase.call(testProduct);

        // Assert
        expect(result, equals(const Right<Failure, void>(null)));
        verify(() => mockRepository.updateProduct(testProduct)).called(1);
      },
    );

    test('should return Failure when repository fails', () async {
      // Arrange
      final failure = ServerFailure('Update failed');
      when(
        () => mockRepository.updateProduct(testProduct),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase.call(testProduct);

      // Assert
      expect(result, equals(Left(failure)));
      verify(() => mockRepository.updateProduct(testProduct)).called(1);
    });
  });
}
