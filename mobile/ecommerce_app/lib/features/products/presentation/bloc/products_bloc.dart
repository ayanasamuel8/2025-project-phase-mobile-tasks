import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/view_all_products.dart';
import '../../domain/usecases/view_product.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ViewAllProductsUsecase getAllProducts;
  final ViewProductUsecase getProductById;
  final CreateProductUsecase createProduct;
  final UpdateProductUsecase updateProduct;
  final DeleteProductUsecase deleteProduct;

  ProductsBloc({
    required this.getAllProducts,
    required this.getProductById,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(InitialState()) {
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<GetSingleProductEvent>(_onGetSingleProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<CreateProductEvent>(_onCreateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  // --- Handlers for each event ---

  void _onLoadAllProducts(
    LoadAllProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(LoadingState());
    final result = await getAllProducts();
    result.fold(
      (failure) => emit(ErrorState(failure.toString())),
      (products) => emit(LoadedAllProductsState(products)),
    );
  }

  void _onGetSingleProduct(
    GetSingleProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final result = await getProductById(event.productId);
    result.fold(
      (failure) => emit(ErrorState(failure.toString())),
      (product) => emit(LoadedSingleProductState(product)),
    );
  }

  void _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final result = await updateProduct(
      Product(
        id: event.productId,
        description: event.description,
        imageUrl: event.imageUrl,
        name: event.name,
        price: event.price,
      ),
    );
    result.fold(
      (failure) => emit(ErrorState(failure.toString())),
      (_) => emit(const UpdatedProductState()),
    );
  }

  void _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final result = await createProduct(
      ProductParams(
        description: event.description,
        imageUrl: event.imageUrl,
        name: event.name,
        price: event.price,
      ),
    );
    result.fold(
      (failure) => emit(ErrorState(failure.toString())),
      (_) => emit(const CreatedProductState()),
    );
  }

  void _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final result = await deleteProduct(event.productId);
    result.fold(
      (failure) => emit(ErrorState(failure.toString())),
      (_) => emit(const DeletedProductState()),
    );
  }
}
