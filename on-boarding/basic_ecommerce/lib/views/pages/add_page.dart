import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:basic_ecommerce/views/widgets/product_form.dart';
import 'package:basic_ecommerce/model/product.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  void _handleAddProduct(Product product) {
    print('Adding Product: ${product.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Add Product',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.indigo),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ProductForm(
        submitButtonText: 'Add',
        onSubmit: (product) {
          _handleAddProduct(product);
          Navigator.pop(context); // Go back after adding
        },
      ),
    );
  }
}
