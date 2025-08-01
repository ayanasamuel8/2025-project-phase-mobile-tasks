part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadAllProductsEvent extends ProductsEvent {
  const LoadAllProductsEvent();

  @override
  List<Object> get props => [];
}

class GetSingleProductEvent extends ProductsEvent {
  final String productId;

  const GetSingleProductEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateProductEvent extends ProductsEvent {
  final String productId;
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  const UpdateProductEvent({
    required this.productId,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [productId, name, price, description, imageUrl];
}

class DeleteProductEvent extends ProductsEvent {
  final String productId;

  const DeleteProductEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class CreateProductEvent extends ProductsEvent {
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  const CreateProductEvent({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [name, price, description, imageUrl];
}
