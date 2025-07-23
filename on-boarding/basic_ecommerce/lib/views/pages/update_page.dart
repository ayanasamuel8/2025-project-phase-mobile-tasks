// lib/views/update_page.dart (Refactored)
import 'package:flutter/material.dart';
import 'package:basic_ecommerce/views/widgets/product_form.dart';
import 'package:basic_ecommerce/model/product.dart';

class UpdatePage extends StatelessWidget {
  final Product product;

  const UpdatePage({super.key, required this.product});

  void _handleUpdateProduct(BuildContext context, Product updatedProduct) {
    print('Updating Product: ${updatedProduct.title}');
    // Logic to update the product via API/state management
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Update Product')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.indigo),
          onPressed: () => Navigator.pop(context),
        ),

        // 3. Conditionally show delete button in the AppBar for better UX
      ),
      body: ProductForm(
        initialProduct: product, // Pass the existing product data
        submitButtonText: 'Update',
        onSubmit: (updatedProduct) {
          _handleUpdateProduct(context, updatedProduct);
        },
      ),
    );
  }
}
