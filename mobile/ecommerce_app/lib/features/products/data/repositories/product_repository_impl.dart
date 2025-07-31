import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, void>> createProduct(Product product) {
    return networkInfo.isConnected.then((isConnected) async {
      if (isConnected) {
        try {
          await remoteDataSource.createProduct(
            ProductModel.fromEntity(product),
          );
          return const Right(null);
        } catch (e) {
          return const Left(ServerFailure('Failed to create product'));
        }
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    });
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProduct(id);
        return const Right(null);
      } catch (e) {
        return const Left(ServerFailure('Failed to delete product'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    try {
      if (await networkInfo.isConnected) {
        final products = await remoteDataSource.getAllProducts();
        localDataSource.cacheAllProduct(products);
        return Right(products);
      } else {
        try {
          final products = await localDataSource.getAllCachedProducts();
          return Right(products);
        } catch (e) {
          return const Left(CacheFailure('No cached data'));
        }
      }
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch products'));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(String id) {
    return networkInfo.isConnected.then((isConnected) async {
      if (isConnected) {
        try {
          final product = await remoteDataSource.getProductById(id);
          return Right(product);
        } catch (e) {
          return const Left(ServerFailure('Failed to fetch product'));
        }
      } else {
        try {
          final product = await localDataSource.getCachedProductById(id);
          return Right(product);
        } catch (e) {
          return const Left(CacheFailure('Product not found in cache'));
        }
      }
    });
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) {
    return networkInfo.isConnected.then((isConnected) async {
      if (isConnected) {
        try {
          await remoteDataSource.updateProduct(
            ProductModel.fromEntity(product),
          );
          return const Right(null);
        } catch (e) {
          return const Left(ServerFailure('Failed to update product'));
        }
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    });
  }
}
