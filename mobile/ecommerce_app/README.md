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

Refer to the test files for specific examples and details.
