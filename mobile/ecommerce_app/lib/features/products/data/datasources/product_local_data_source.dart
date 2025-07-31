import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getAllCachedProducts();
  Future<ProductModel> getCachedProductById(int id);
  Future<bool> cacheAllProduct(List<ProductModel> products);
}

const cachedProducts = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<ProductModel>> getAllCachedProducts() async {
    final jsonString = sharedPreferences.getString(cachedProducts);
    if (jsonString == null) {
      throw CacheException('no chached data');
    }
    return Future.value(
      (List<Map<String, dynamic>>.from(
        json.decode(jsonString) as List,
      )).map((json) => ProductModel.fromJson(json)).toList(),
    );
  }

  @override
  Future<ProductModel> getCachedProductById(int id) async {
    return ProductModel(
      id: id,
      name: 'Product $id',
      price: 0,
      description: 'Description for product $id',
      imageUrl: 'http://example.com/product$id.jpg',
    );
  }

  @override
  Future<bool> cacheAllProduct(List<ProductModel> products) async {
    return sharedPreferences.setString(
      cachedProducts,
      json.encode(products.map((product) => product.toJson()).toList()),
    );
  }
}
