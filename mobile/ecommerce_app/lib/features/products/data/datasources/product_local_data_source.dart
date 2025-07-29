import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getAllChachedProducts();
  Future<ProductModel> getProductById(int id);
  Future<void> chacheProduct(ProductModel product);
}
