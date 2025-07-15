import 'dart:io';
import 'src/manager/product_manager.dart';
import 'src/models/product.dart';

void runApp() {
  final productManager = ProductManager();

  while (true) {
    print('\n================== Product Management ==================');
    print('1. View all products');
    print('2. View product by ID');
    print('3. Add a product');
    print('4. Update a product');
    print('5. Delete a product');
    print('6. Exit');

    print('==========================================================');
    stdout.write('Select an option: ');
    final input = stdin.readLineSync();
    print('********************************************');

    switch (input) {
      case '1':
        final products = productManager.getAllProducts;
        if (products.isEmpty) {
          print('No products available.');
        } else {
          for (var product in products) {
            print(product);
          }
        }
        break;
      case '2':
        stdout.write('Enter product ID: ');
        final idInput = stdin.readLineSync();
        if (idInput != null && int.tryParse(idInput) != null) {
          final product = productManager.getProductById(int.parse(idInput));
          if (product != null) {
            print(product);
          } else {
            print('Product not found.');
          }
        } else {
          print('Invalid ID input.');
        }
        break;
      case '3':
        stdout.write('Enter product name: ');
        final name = stdin.readLineSync();
        stdout.write('Enter product price: ');
        final priceInput = stdin.readLineSync();
        final price = double.tryParse(priceInput ?? '');
        stdout.write('Enter product description (optional): ');
        final description = stdin.readLineSync();

        if (name != null && price != null && price > 0) {
          try {
            final product = Product(
              name: name,
              price: price,
              description: description,
            );
            if (productManager.addProduct(product)) {
              print('Product added successfully.');
            } else {
              print('Failed to add product.');
            }
          } catch (e) {
            print('Error adding product: $e');
          }
        } else {
          print('Invalid input for name or price.');
        }
        break;
      case '4':
        stdout.write('Enter product ID to update: ');
        final updateIdInput = stdin.readLineSync();
        if (updateIdInput != null && int.tryParse(updateIdInput) != null) {
          final id = int.parse(updateIdInput);
          final existingProduct = productManager.getProductById(id);
          if (existingProduct != null) {
            stdout.write('Enter new name (current: ${existingProduct.name}): ');
            final newName = stdin.readLineSync() ?? existingProduct.name;
            stdout.write(
              'Enter new price (current: ${existingProduct.price}): ',
            );
            final newPriceInput = stdin.readLineSync();
            final newPrice =
                double.tryParse(newPriceInput ?? '') ?? existingProduct.price;
            stdout.write(
              'Enter new description (current: ${existingProduct.description}): ',
            );
            final newDescription =
                stdin.readLineSync() ?? existingProduct.description;

            try {
              final updatedProduct = Product(
                name: newName,
                price: newPrice,
                description: newDescription,
              );
              updatedProduct.id = existingProduct.id;
              if (productManager.updateProduct(updatedProduct)) {
                print('Product updated successfully.');
              } else {
                print('Failed to update product.');
              }
            } catch (e) {
              print('Error updating product: $e');
            }
          } else {
            print('Product not found.');
          }
        } else {
          print('Invalid ID input.');
        }
        break;
      case '5':
        stdout.write('Enter product ID to delete: ');
        final deleteIdInput = stdin.readLineSync();
        if (deleteIdInput != null && int.tryParse(deleteIdInput) != null) {
          final id = int.parse(deleteIdInput);
          if (productManager.deleteProduct(id)) {
            print('Product deleted successfully.');
          } else {
            print('Failed to delete product.');
          }
        } else {
          print('Invalid ID input.');
        }
        break;
      case '6':
        print('Exiting...');
        return;
      default:
        print('Invalid option. Please try again.');
        break;
    }
    print('********************************************');
  }
}
