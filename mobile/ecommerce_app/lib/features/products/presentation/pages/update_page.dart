import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../bloc/products_bloc.dart';
import '../widgets/product_form.dart';

class UpdatePage extends StatelessWidget {
  final String productId;
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  const UpdatePage({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  void _handleUpdateProduct(
    BuildContext context,
    String id,
    String name,
    String description,
    double price,
    String imageUrl,
  ) {
    context.read<ProductsBloc>().add(
      UpdateProductEvent(
        productId: id,
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Update Product')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CustomColor.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
          if (state is UpdatedProductState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Product updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          return ProductForm(
            initialProductId: productId,
            initialProductName: name,
            initialProductPrice: price,
            initialProductDescription: description,
            initialProductImageUrl: imageUrl,
            submitButtonText: 'Update',
            onSubmit: (id, name, description, price, imageUrl) {
              _handleUpdateProduct(
                context,
                id,
                name,
                description,
                price,
                imageUrl,
              );
            },
          );
        },
      ),
    );
  }
}
