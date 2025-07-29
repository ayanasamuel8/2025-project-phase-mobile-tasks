import 'package:ecommerce_app/core/platform/network_info.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}

class MockLocalDataSource extends Mock implements ProductLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
}
