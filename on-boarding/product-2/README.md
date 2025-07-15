
# 🛒 Product 2 Project

This project is a Dart-based application for managing products, including their creation, storage, and retrieval. It is organized for clarity and modularity, making it easy to extend or integrate into larger systems.


## 🗂️ Project Structure


- 📁 `bin/` — Entry point for the application (e.g., `main.dart`).
- 📦 `lib/`
  - 🧩 `app.dart` — Main application logic.
  - 📂 `src/`
    - 🗃️ `Data/`
      - 📝 `products.json` — Example data file for products.
    - 🧑‍💼 `manager/`
      - 🛠️ `product_manager.dart` — Handles product management logic.
    - 🏷️ `models/`
      - 🛍️ `Product.dart` — Defines the `Product` class and its serialization.
    - 💾 `storage/`
      - 📄 `file_storage.dart` — Handles file-based storage for products.
- 📄 `pubspec.yaml` — Dart/Flutter dependencies and project metadata.
- 📄 `pubspec.lock` — Locked dependency versions.


## ✨ Features
- 🛍️ Product model with validation and JSON serialization.
- 🧑‍💼 Product management (add, update, delete, list).
- 💾 File-based storage for persistence.
- 📝 Example data and entry point for running the app.


## 🚀 Getting Started
1. 🛠️ Ensure you have Dart SDK installed.
2. 📦 Get dependencies:
   ```sh
   dart pub get
   ```
3. ▶️ Run the application:
   ```sh
   dart run
   ```


## 🧑‍🎨 Customization
- ✨ Add new features by extending the models or manager classes.
- 📝 Update `products.json` for sample data.


## 📄 License
This project is for educational purposes.
