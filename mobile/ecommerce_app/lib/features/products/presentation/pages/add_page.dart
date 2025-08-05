import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/styles.dart';
import '../bloc/products_bloc.dart';
import '../widgets/product_form.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  void _handleAddProduct(
    BuildContext context,
    String name,
    String description,
    double price,
    String imagePath,
  ) {
    context.read<ProductsBloc>().add(
      CreateProductEvent(
        name: name,
        description: description,
        price: price,
        imageUrl: imagePath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Product', style: h2())),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.indigo),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ProductForm(
        submitButtonText: 'Add',
        onSubmit: (name, description, price, imagePath) {
          _handleAddProduct(context, name, description, price, imagePath);
          Navigator.pop(context); // Go back after adding
        },
      ),
    );
  }
}
