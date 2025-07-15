import '../models/product.dart';
import '../storage/file_storage.dart';

class ProductManager {
  final FileStorage _fileStorage = FileStorage();

  late final List<Product> _products;

  ProductManager() {
    _products = _fileStorage.loadProducts();
  }

  List<Product> get getAllProducts => List.unmodifiable(_products);

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      print('Product with id $id not found');
      return null;
    }
  }

  bool addProduct(Product product) {
    if (_products.any((p) => p.id == product.id)) {
      print('Product with id ${product.id} already exists');
      return false;
    }
    _products.add(product);
    return _fileStorage.saveProducts(_products);
  }

  bool updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index == -1) {
      print('Product with id ${updatedProduct.id} not found');
      return false;
    }
    _products[index] = updatedProduct;
    return _fileStorage.saveProducts(_products);
  }

  bool deleteProduct(int id) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index == -1) {
      print('[WARN] Product with id $id not found during getProductById');
      return false;
    }
    _products.removeAt(index);
    return _fileStorage.saveProducts(_products);
  }
}
