import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUsecase {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  Future<void> call(Product product) async {
    await repository.createProduct(product);
  }
}
