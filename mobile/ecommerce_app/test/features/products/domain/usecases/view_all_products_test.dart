import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/products/domain/usecases/view_all_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of [ProductRepository] using mocktail.
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ViewAllProductsUsecase usecase;
  late MockProductRepository mockRepository;

  const List<Product> testProducts = [];

  setUp(() {
    mockRepository = MockProductRepository();
    usecase = ViewAllProductsUsecase(mockRepository);

    // Fallback if mocktail needs it
    registerFallbackValue(
      Product(id: '0', name: '', price: 0.0, description: '', imageUrl: ''),
    );
  });

  group('ViewAllProductsUsecase', () {
    test(
      'should call getAllProducts on the repository and return a list of products',
      () async {
        // Arrange
        when(
          () => mockRepository.getAllProducts(),
        ).thenAnswer((_) async => const Right(testProducts));

        // Act
        final result = await usecase.call();

        // Assert
        expect(result, equals(const Right(testProducts)));
        verify(() => mockRepository.getAllProducts()).called(1);
      },
    );

    test('should return Failure when repository throws', () async {
      // Arrange
      final failure = const ServerFailure('Failed to fetch products');
      when(
        () => mockRepository.getAllProducts(),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase.call();

      // Assert
      expect(result, equals(Left(failure)));
      verify(() => mockRepository.getAllProducts()).called(1);
    });
  });
}
