import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getAllCachedProducts();
  Future<ProductModel> getCachedProductById(int id);
  Future<void> cacheProduct(ProductModel product);
  Future<void> cacheAllProduct(List<ProductModel> products);
}
