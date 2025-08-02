import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/products/data/datasources/product_local_data_source.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/create_product.dart';
import 'features/products/domain/usecases/delete_product.dart';
import 'features/products/domain/usecases/update_product.dart';
import 'features/products/domain/usecases/view_all_products.dart';
import 'features/products/domain/usecases/view_product.dart';
import 'features/products/presentation/bloc/products_bloc.dart';

// ... (all your other imports)

final sl = GetIt.instance;

Future<void> init() async {
  // ===================================================================
  // PRESENTATION LAYER (BLoCs)
  // Depends on: Use Cases
  // ===================================================================
  sl.registerFactory(
    () => ProductsBloc(
      // This is the final version, using the use cases
      getAllProducts: sl(),
      getProductById: sl(),
      createProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
    ),
  );

  // ===================================================================
  // DOMAIN LAYER (USE CASES)
  // Depends on: Repositories
  // ===================================================================
  sl.registerLazySingleton(() => CreateProductUsecase(sl()));
  sl.registerLazySingleton(() => ViewAllProductsUsecase(sl()));
  sl.registerLazySingleton(() => ViewProductUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(sl()));

  // ===================================================================
  // DATA LAYER
  // Depends on: Data Sources, Core Services
  // ===================================================================
  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sl()),
  );

  // ===================================================================
  // CORE
  // Depends on: External Packages
  // ===================================================================
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ===================================================================
  // EXTERNAL PACKAGES (Foundation with no dependencies)
  // ===================================================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
