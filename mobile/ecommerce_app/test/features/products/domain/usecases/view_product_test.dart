import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/products/domain/usecases/view_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of ProductRepository
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ViewProductUsecase usecase;
  late MockProductRepository mockRepository;

  const productId = '1';

  final testProduct = Product(
    id: productId,
    name: 'Test',
    price: 10.0,
    description: 'Test product',
    imageUrl: 'http://example.com/image.jpg',
  );

  setUp(() {
    mockRepository = MockProductRepository();
    usecase = ViewProductUsecase(mockRepository);
  });

  group('ViewProductUsecase', () {
    test(
      'should return a product when repository returns Right(product)',
      () async {
        // Arrange
        when(
          () => mockRepository.getProductById(productId),
        ).thenAnswer((_) async => Right(testProduct));

        // Act
        final result = await usecase.call(productId);

        // Assert
        expect(result, equals(Right(testProduct)));
        verify(() => mockRepository.getProductById(productId)).called(1);
      },
    );

    test(
      'should return Failure when repository returns Left(Failure)',
      () async {
        // Arrange
        final failure = ServerFailure('Unable to fetch product');
        when(
          () => mockRepository.getProductById(productId),
        ).thenAnswer((_) async => Left(failure));

        // Act
        final result = await usecase.call(productId);

        // Assert
        expect(result, equals(Left(failure)));
        verify(() => mockRepository.getProductById(productId)).called(1);
      },
    );
  });
}
