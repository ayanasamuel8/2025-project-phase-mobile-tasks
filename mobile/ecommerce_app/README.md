# 🛒ecommerce_app

A new Flutter project.

## 🚀Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 🧹Linter Setup & Usage

This project uses [Flutter Lints](https://pub.dev/packages/flutter_lints) for enforcing coding standards and best practices.

Linter configuration is found in `analysis_options.yaml`.

### How to Run Linter

To analyze your code and check for lint issues, run:

```powershell
flutter analyze
```

This will display any errors, warnings, or lint violations in your codebase.

### Custom Rules

You can customize lint rules in `analysis_options.yaml` under the `linter` section.
 
## 🏛️Domain Layer

The `lib/features/products/domain` directory implements the Domain Layer of the app, following clean architecture principles. This layer contains the core business logic and abstractions for the product feature.

**Structure:**
 - 📦 `entities/`: Contains domain models such as `product.dart`.
 - 🗂️ `repositories/`: Defines repository interfaces, e.g., `product_repository.dart`.
 - 🛠️ `usecases/`: Contains use case classes for product operations, such as:
    - ✏️ `create_product.dart`
    - ❌ `delete_product.dart`
    - 📝 `update_product.dart`
    - 👀 `view_all_products.dart`
    - 🔍 `view_product.dart`

**Purpose:**
 - 🧠 Keeps business logic independent from UI and data layers.
 - 🛠️ Makes the codebase more maintainable, testable, and scalable.

Refer to the files in `lib/features/products/domain/` for details on each component.

---

## 🧪Usecase Tests

Unit tests are provided for each usecase in the domain layer to ensure correct business logic and repository interaction. These tests use the `mocktail` package to mock dependencies and verify expected behavior.

**Test files:**
 - ✏️ `test/features/products/domain/usecases/create_product_test.dart`
 - ❌ `test/features/products/domain/usecases/delete_product_test.dart`
 - 📝 `test/features/products/domain/usecases/update_product_test.dart`
 - 👀 `test/features/products/domain/usecases/view_all_products_test.dart`
 - 🔍 `test/features/products/domain/usecases/view_product_test.dart`

**What is tested:**
 - ✅ Each usecase calls the correct repository method with expected arguments.
 - 🟢 Success and 🔴 failure scenarios are covered using mocked responses.
 - 🧾 The tests verify that the usecase returns the correct result type (`Right` for success, `Left` for failure`).

🧑‍🔬To run all tests:

```powershell
flutter test
```

📝 Refer to the test files for specific examples and details.

---

## 🗄️Data Layer Architecture & Flow

The Data Layer is responsible for all data-related operations in the app, including fetching, storing, and transforming data. It acts as the bridge between external data sources (APIs, databases) and the domain layer.

### Structure
 - **Models:**
   - Located in `lib/features/products/data/models/`.
   - Example: `ProductModel` extends the domain `Product` entity and adds serialization/deserialization logic.
 - **(Extendable):**
   - As the app grows, you can add `datasources/` for API/local storage logic and `repositories/` for concrete implementations.

### Data Flow
1. **Fetching Data:**
   - Data is fetched from an external source (e.g., API) and parsed into a `ProductModel` using `ProductModel.fromJson()`.
2. **Mapping to Domain:**
   - `ProductModel` inherits from the domain `Product` entity, so it can be used directly in business logic.
3. **Saving/Updating Data:**
   - When saving or updating, `ProductModel.toJson()` converts the model back to a map for transmission/storage.

### Example Usage
```dart
final productMap = json.decode(productJson);
final productModel = ProductModel.fromJson(productMap);
// Use productModel in your app or pass to domain layer
final jsonMap = productModel.toJson();
```

### Data Layer Tests & Fixtures
 - Tests for the data layer are located in `test/features/products/data/models/product_model_test.dart`.
 - These tests use fixture files to provide consistent sample data for verifying model behavior.
 - The fixture system loads a sample JSON file (e.g., `product.json`) and decodes it for use in tests.

**What is tested:**
 - Correct parsing from JSON to model (`fromJson`).
 - Correct conversion from model to JSON (`toJson`).
 - Symmetry between `fromJson` and `toJson` (round-trip conversion).

**Sample test:**
```dart
test('fromJson returns correct ProductModel', () {
  final model = ProductModel.fromJson(productMap);
  expect(model.id, 1);
  expect(model.name, 'Product Name');
  // ...other assertions
});
```

**How to run data layer tests:**
```powershell
flutter test test/features/products/data/models/product_model_test.dart
```


## 🗄️Data Layer Components & Integration

Recent changes have added key data layer components to support robust data management and separation of concerns:

### Core Utilities
 - `core/error/exceptions.dart`: Defines custom exceptions (`ServerException`, `CacheException`) for error handling in data operations.
 - `core/platform/network_info.dart`: Abstracts network connectivity checks, allowing repositories to decide between remote and local sources.

### Data Sources
 - `features/products/data/datasources/product_local_data_source.dart`: Interface for local product data operations (cache, local storage).
 - `features/products/data/datasources/product_remote_data_source.dart`: Interface for remote product data operations (API calls).

### Repository Implementation
 - `features/products/data/repositories/product_repository_impl.dart`: Implements the domain repository interface, orchestrating data flow between remote/local sources and handling network logic. Methods are currently stubbed for future implementation.

### Data Layer Test
 - `test/features/products/data/repositories/product_repository_impl_test.dart`: Sets up unit tests for the repository implementation using `mocktail` to mock data sources and network info. Ensures correct integration and interaction between components.

### Data Flow Example
1. UI requests product data via a usecase.
2. Usecase calls the repository (`ProductRepositoryImpl`).
3. Repository checks network status using `NetworkInfo`.
4. Depending on connectivity, it fetches data from either `ProductRemoteDataSource` or `ProductLocalDataSource`.
5. Data is returned as domain entities, with errors handled via custom exceptions.

### How to Test Repository Integration
Run:
```powershell
flutter test test/features/products/data/repositories/product_repository_impl_test.dart
```
This will verify the repository's interaction with data sources and network info.

---

## 🏗️App Architecture Overview

The app follows a layered, clean architecture:

1. **Presentation Layer:** Handles UI and user interaction (not covered here).
2. **Domain Layer:** Contains business logic, entities, and usecases.
3. **Data Layer:** Handles data operations, mapping, and repository implementations.

**Data flow:**
 - UI requests data via usecases (domain layer).
 - Usecases interact with repositories, which delegate to the data layer for actual data fetching/saving.
 - Data layer fetches/parses data, maps it to domain entities, and returns it up the chain.

This separation ensures maintainability, testability, and scalability.