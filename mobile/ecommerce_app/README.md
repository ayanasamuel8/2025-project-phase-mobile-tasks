# 🛒 ecommerce_app

A new Flutter project.

---

## 🚀 Getting Started

This project is a starting point for a Flutter application.

Helpful resources:
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter documentation](https://docs.flutter.dev/)

---

## 🧹 Linter Setup

This project uses [Flutter Lints](https://pub.dev/packages/flutter_lints) for coding standards.

- Configuration: `analysis_options.yaml`

**Run linter:**
```powershell
flutter analyze
```

**Custom rules:**  
Edit the `linter` section in `analysis_options.yaml`.

---

## 🏗️ App Architecture Overview

The app follows a layered, clean architecture:

1. **Presentation Layer:** UI and user interaction (not covered here)
2. **Domain Layer:** Business logic, entities, usecases
3. **Data Layer:** Data operations, mapping, repository implementations

**Data flow:**
- UI requests data via usecases (domain layer)
- Usecases interact with repositories, which delegate to the data layer
- Data layer fetches/parses data, maps to domain entities, and returns up the chain

---

## 🏛️ Domain Layer

Located in `lib/features/products/domain`, following clean architecture principles.

**Structure:**
- `entities/`: Domain models (e.g., `product.dart`)
- `repositories/`: Repository interfaces (e.g., `product_repository.dart`)
- `usecases/`: Use case classes:
   - `create_product.dart`
   - `delete_product.dart`
   - `update_product.dart`
   - `view_all_products.dart`
   - `view_product.dart`

**Purpose:**
- Keeps business logic independent from UI/data layers
- Improves maintainability, testability, scalability

Refer to files in `lib/features/products/domain/` for details.

---

## 🧪 Usecase Tests

Unit tests ensure correct business logic and repository interaction. Uses `mocktail` for mocking.

**Test files:**
- `create_product_test.dart`
- `delete_product_test.dart`
- `update_product_test.dart`
- `view_all_products_test.dart`
- `view_product_test.dart`

**Test coverage:**
- Correct repository method calls
- Success and failure scenarios
- Correct result types (`Right` for success, `Left` for failure)

**Run all tests:**
```powershell
flutter test
```

---

## 🗄️ Data Layer

Handles data operations, bridging external sources and domain layer.

### Structure
- **Models:**  
   `lib/features/products/data/models/`  
   Example: `ProductModel` extends domain `Product` and adds serialization.

- **Extendable:**  
   Add `datasources/` for API/local logic and `repositories/` for implementations.

### Data Flow
1. Fetch data from external source, parse with `ProductModel.fromJson()`
2. Use `ProductModel` in business logic (inherits domain entity)
3. Save/update with `ProductModel.toJson()`

**Example:**
```dart
final productMap = json.decode(productJson);
final productModel = ProductModel.fromJson(productMap);
final jsonMap = productModel.toJson();
```

### Data Layer Tests & Fixtures
- Tests: `product_model_test.dart`
- Uses fixture files (e.g., `product.json`) for sample data

**Test coverage:**
- Parsing from JSON (`fromJson`)
- Conversion to JSON (`toJson`)
- Round-trip conversion

**Sample test:**
```dart
test('fromJson returns correct ProductModel', () {
   final model = ProductModel.fromJson(productMap);
   expect(model.id, 1);
   expect(model.name, 'Product Name');
});
```

**Run data layer tests:**
```powershell
flutter test test/features/products/data/models/product_model_test.dart
```

---

## 🗄️ Data Layer Components & Integration

Recent additions for robust data management:

### Core Utilities
- `core/error/exceptions.dart`: Custom exceptions (`ServerException`, `CacheException`)
- `core/platform/network_info.dart`: Network connectivity abstraction

### Data Sources
- `product_local_data_source.dart`: Local data operations
- `product_remote_data_source.dart`: Remote data operations

### Repository Implementation
- `product_repository_impl.dart`: Implements domain repository, orchestrates data flow, handles network logic

### Data Layer Test
- `product_repository_impl_test.dart`: Unit tests for repository implementation, mocks data sources/network info

### Data Flow Example
1. UI requests product data via usecase
2. Usecase calls repository (`ProductRepositoryImpl`)
3. Repository checks network status
4. Fetches from remote/local source accordingly
5. Returns domain entities, handles errors via exceptions

**Test repository integration:**
```powershell
flutter test test/features/products/data/repositories/product_repository_impl_test.dart
```

---

## 🗂️ ProductRepositoryImpl Implementation & Tests

### Overview
`ProductRepositoryImpl` coordinates remote/local data sources, network checks, and error handling.

**Responsibilities:**
- Checks network before remote operations
- Delegates to remote/local sources
- Converts entities to models for transmission/storage
- Handles errors, returns `Either<Failure, T>`

**Implemented methods:**
- `getAllProducts()`
- `createProduct(product)`
- `deleteProduct(id)`
- `getProductById(id)`
- `updateProduct(product)`

### Repository Tests
- Location: `product_repository_impl_test.dart`
- Uses `mocktail` for mocking
- Verifies delegation, network checks, error handling, caching

**Run repository tests:**
```powershell
flutter test test/features/products/data/repositories/product_repository_impl_test.dart
```

Refer to the test file for detailed scenarios.

---

## 🌐 NetworkInfo Implementation

The `NetworkInfo` class abstracts network connectivity checks for the app. It allows repositories and data sources to determine whether to use remote or local data sources based on the device's connection status.

**Location:**
- `lib/core/platform/network_info.dart`

**Usage:**
- Injected into repositories (e.g., `ProductRepositoryImpl`) to check connectivity before performing remote operations.
- Enables robust offline support and error handling.

**Testing:**
- In unit tests, `NetworkInfo` is mocked to simulate online/offline scenarios and verify repository behavior.

