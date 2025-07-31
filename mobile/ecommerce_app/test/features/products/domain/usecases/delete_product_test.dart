import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/products/domain/usecases/delete_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of ProductRepository using mocktail
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late DeleteProductUsecase usecase;
  late MockProductRepository mockRepository;

  // Common product used across tests
  Product testProduct = Product(
    id: '1',
    name: 'Test Product',
    price: 10.0,
    description: 'A test product',
    imageUrl: 'https://example.com/test.jpg',
  );

  setUp(() {
    mockRepository = MockProductRepository();
    usecase = DeleteProductUsecase(mockRepository);

    // Registering fallback value for int (used as product id)
    registerFallbackValue(0);
  });

  group('DeleteProductUsecase', () {
    test(
      'should call deleteProduct on repository with correct product ID',
      () async {
        // Arrange
        when(
          () => mockRepository.deleteProduct(testProduct.id),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await usecase.call(testProduct.id);

        // Assert
        expect(result, equals(const Right<Failure, void>(null)));
        verify(() => mockRepository.deleteProduct(testProduct.id)).called(1);
      },
    );

    test('should return Failure when repository fails', () async {
      // Arrange
      final failure = const ServerFailure('Deletion failed');
      when(
        () => mockRepository.deleteProduct(testProduct.id),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase.call(testProduct.id);

      // Assert
      expect(result, equals(Left(failure)));
      verify(() => mockRepository.deleteProduct(testProduct.id)).called(1);
    });
  });
}
