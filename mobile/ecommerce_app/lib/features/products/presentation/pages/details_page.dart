import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/styles.dart';
import '../../domain/entities/product.dart';
import '../bloc/products_bloc.dart';

// 1. Convert to a StatefulWidget to use initState
class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.productId});
  final String productId;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductsBloc>(
      context,
    ).add(GetSingleProductEvent(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProductsBloc, ProductsState>(
        listener: (context, state) {
          if (state is LoadedAllProductsState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Product deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
          // Show an error message if deletion fails.
          else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoadedSingleProductState) {
              return _productDetailsWidget(state.product, context);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _productDetailsWidget(Product product, BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.network(
              product.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: CustomColor.primary,
                ),
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(product.name, style: h1())),
                      const SizedBox(width: 10),
                      Text('\$${product.price}', style: h1()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(product.description, style: h3()),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  context.read<ProductsBloc>().add(
                    DeleteProductEvent(product.id),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  maximumSize: const Size(150, 50),
                  minimumSize: const Size(100, 40),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/update',
                    arguments: {
                      'productId': product.id,
                      'name': product.name,
                      'price': product.price,
                      'description': product.description,
                      'imageUrl': product.imageUrl,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  maximumSize: const Size(150, 50),
                  minimumSize: const Size(100, 40),
                ),
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
