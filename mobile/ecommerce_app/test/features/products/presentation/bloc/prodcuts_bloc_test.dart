import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/usecases/create_product.dart';
import 'package:ecommerce_app/features/products/domain/usecases/delete_product.dart';
import 'package:ecommerce_app/features/products/domain/usecases/update_product.dart';
import 'package:ecommerce_app/features/products/domain/usecases/view_all_products.dart';
import 'package:ecommerce_app/features/products/domain/usecases/view_product.dart';
import 'package:ecommerce_app/features/products/presentation/bloc/products_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock Usecases using mocktail
class MockViewAllProductsUsecase extends Mock
    implements ViewAllProductsUsecase {}

class MockViewProductUsecase extends Mock implements ViewProductUsecase {}

class MockCreateProductUsecase extends Mock implements CreateProductUsecase {}

class MockUpdateProductUsecase extends Mock implements UpdateProductUsecase {}

class MockDeleteProductUsecase extends Mock implements DeleteProductUsecase {}

void main() {
  late MockViewAllProductsUsecase mockViewAllProductsUsecase;
  late MockViewProductUsecase mockViewProductUsecase;
  late MockCreateProductUsecase mockCreateProductUsecase;
  late MockUpdateProductUsecase mockUpdateProductUsecase;
  late MockDeleteProductUsecase mockDeleteProductUsecase;
  late ProductsBloc productsBloc;

  setUp(() {
    mockViewAllProductsUsecase = MockViewAllProductsUsecase();
    mockViewProductUsecase = MockViewProductUsecase();
    mockCreateProductUsecase = MockCreateProductUsecase();
    mockUpdateProductUsecase = MockUpdateProductUsecase();
    mockDeleteProductUsecase = MockDeleteProductUsecase();

    productsBloc = ProductsBloc(
      getAllProducts: mockViewAllProductsUsecase,
      getProductById: mockViewProductUsecase,
      createProduct: mockCreateProductUsecase,
      updateProduct: mockUpdateProductUsecase,
      deleteProduct: mockDeleteProductUsecase,
    );

    // Register fallback values for any() matcher
    registerFallbackValue(
      const Product(id: '', name: '', description: '', price: 0, imageUrl: ''),
    );
    registerFallbackValue(
      const ProductParams(name: '', description: '', price: 0, imageUrl: ''),
    );
  });

  tearDown(() {
    productsBloc.close();
  });

  const tProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    price: 99.99,
    imageUrl: 'http://example.com/image.png',
  );

  final tProductList = [tProduct];
  const tServerFailure = ServerFailure('Server Error');

  test('initial state should be InitialState', () {
    expect(productsBloc.state, equals(InitialState()));
  });

  group('LoadAllProductsEvent', () {
    blocTest<ProductsBloc, ProductsState>(
      'should emit [LoadingState, LoadedAllProductsState] when data is gotten successfully',
      build: () {
        when(
          () => mockViewAllProductsUsecase(),
        ).thenAnswer((_) async => Right(tProductList));
        return productsBloc;
      },
      act: (bloc) => bloc.add(const LoadAllProductsEvent()),
      expect: () => [LoadingState(), LoadedAllProductsState(tProductList)],
      verify: (_) {
        verify(() => mockViewAllProductsUsecase());
        verifyNoMoreInteractions(mockViewAllProductsUsecase);
      },
    );

    blocTest<ProductsBloc, ProductsState>(
      'should emit [LoadingState, ErrorState] when getting data fails',
      build: () {
        when(
          () => mockViewAllProductsUsecase(),
        ).thenAnswer((_) async => const Left(tServerFailure));
        return productsBloc;
      },
      act: (bloc) => bloc.add(const LoadAllProductsEvent()),
      expect: () => [LoadingState(), ErrorState(tServerFailure.toString())],
      verify: (_) {
        verify(() => mockViewAllProductsUsecase());
        verifyNoMoreInteractions(mockViewAllProductsUsecase);
      },
    );
  });

  group('GetSingleProductEvent', () {
    const tProductId = '1';
    blocTest<ProductsBloc, ProductsState>(
      'should emit [LoadedSingleProductState] when data is gotten successfully',
      build: () {
        when(
          () => mockViewProductUsecase(any()),
        ).thenAnswer((_) async => const Right(tProduct));
        return productsBloc;
      },
      act: (bloc) => bloc.add(const GetSingleProductEvent(tProductId)),
      expect: () => [const LoadedSingleProductState(tProduct)],
      verify: (_) {
        verify(() => mockViewProductUsecase(tProductId));
        verifyNoMoreInteractions(mockViewProductUsecase);
      },
    );

    blocTest<ProductsBloc, ProductsState>(
      'should emit [ErrorState] when getting data fails',
      build: () {
        when(
          () => mockViewProductUsecase(any()),
        ).thenAnswer((_) async => const Left(tServerFailure));
        return productsBloc;
      },
      act: (bloc) => bloc.add(const GetSingleProductEvent(tProductId)),
      expect: () => [ErrorState(tServerFailure.toString())],
      verify: (_) {
        verify(() => mockViewProductUsecase(tProductId));
        verifyNoMoreInteractions(mockViewProductUsecase);
      },
    );
  });

  group('CreateProductEvent', () {
    const tProductParams = ProductParams(
      name: 'New Product',
      description: 'New Description',
      price: 120.0,
      imageUrl: 'http://example.com/new.png',
    );

    blocTest<ProductsBloc, ProductsState>(
      'should emit [CreatedProductState] when product is created successfully',
      build: () {
        when(
          () => mockCreateProductUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
        return productsBloc;
      },
      act: (bloc) => bloc.add(
        CreateProductEvent(
          name: tProductParams.name,
          description: tProductParams.description,
          price: tProductParams.price,
          imageUrl: tProductParams.imageUrl,
        ),
      ),
      expect: () => [const CreatedProductState()],
      verify: (_) {
        verify(() => mockCreateProductUsecase(tProductParams));
        verifyNoMoreInteractions(mockCreateProductUsecase);
      },
    );

    blocTest<ProductsBloc, ProductsState>(
      'should emit [ErrorState] when product creation fails',
      build: () {
        when(
          () => mockCreateProductUsecase(any()),
        ).thenAnswer((_) async => const Left(tServerFailure));
        return productsBloc;
      },
      act: (bloc) => bloc.add(
        CreateProductEvent(
          name: tProductParams.name,
          description: tProductParams.description,
          price: tProductParams.price,
          imageUrl: tProductParams.imageUrl,
        ),
      ),
      expect: () => [ErrorState(tServerFailure.toString())],
      verify: (_) {
        verify(() => mockCreateProductUsecase(tProductParams));
        verifyNoMoreInteractions(mockCreateProductUsecase);
      },
    );
  });

  group('UpdateProductEvent', () {
    const tUpdateEvent = UpdateProductEvent(
      productId: '1',
      name: 'Updated Name',
      description: 'Updated Desc',
      price: 150.0,
      imageUrl: 'http://example.com/updated.png',
    );

    final tUpdatedProduct = Product(
      id: tUpdateEvent.productId,
      name: tUpdateEvent.name,
      description: tUpdateEvent.description,
      price: tUpdateEvent.price,
      imageUrl: tUpdateEvent.imageUrl,
    );

    blocTest<ProductsBloc, ProductsState>(
      'should emit [UpdatedProductState] when product is updated successfully',
      build: () {
        when(
          () => mockUpdateProductUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
        return productsBloc;
      },
      act: (bloc) => bloc.add(tUpdateEvent),
      expect: () => [const UpdatedProductState()],
      verify: (_) {
        verify(() => mockUpdateProductUsecase(tUpdatedProduct));
        verifyNoMoreInteractions(mockUpdateProductUsecase);
      },
    );

    blocTest<ProductsBloc, ProductsState>(
      'should emit [ErrorState] when product update fails',
      build: () {
        when(
          () => mockUpdateProductUsecase(any()),
        ).thenAnswer((_) async => const Left(tServerFailure));
        return productsBloc;
      },
      act: (bloc) => bloc.add(tUpdateEvent),
      expect: () => [ErrorState(tServerFailure.toString())],
      verify: (_) {
        verify(() => mockUpdateProductUsecase(tUpdatedProduct));
        verifyNoMoreInteractions(mockUpdateProductUsecase);
      },
    );
  });

  group('DeleteProductEvent', () {
    const tProductId = '1';
    blocTest<ProductsBloc, ProductsState>(
      'should emit [DeletedProductState] when product is deleted successfully',
      build: () {
        when(
          () => mockDeleteProductUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
        return productsBloc;
      },
      act: (bloc) => bloc.add(const DeleteProductEvent(tProductId)),
      expect: () => [const DeletedProductState()],
      verify: (_) {
        verify(() => mockDeleteProductUsecase(tProductId));
        verifyNoMoreInteractions(mockDeleteProductUsecase);
      },
    );

    blocTest<ProductsBloc, ProductsState>(
      'should emit [ErrorState] when product deletion fails',
      build: () {
        when(
          () => mockDeleteProductUsecase(any()),
        ).thenAnswer((_) async => const Left(tServerFailure));
        return productsBloc;
      },
      act: (bloc) => bloc.add(const DeleteProductEvent(tProductId)),
      expect: () => [ErrorState(tServerFailure.toString())],
      verify: (_) {
        verify(() => mockDeleteProductUsecase(tProductId));
        verifyNoMoreInteractions(mockDeleteProductUsecase);
      },
    );
  });
}
