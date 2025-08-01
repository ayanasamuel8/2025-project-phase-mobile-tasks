import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUsecase {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  Future<Either<Failure, void>> call(ProductParams product) async {
    return await repository.createProduct(product);
  }
}
