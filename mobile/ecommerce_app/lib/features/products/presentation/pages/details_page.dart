import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/styles.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/product.dart';
import '../bloc/products_bloc.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>
            sl<ProductsBloc>()..add(GetSingleProductEvent(productId)),
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoadedSingleProductState) {
              return productDetailsWidget(state.product, context);
            } else if (state is ErrorState) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Failed to load product'));
            }
          },
        ),
      ),
    );
  }
}

Widget productDetailsWidget(Product product, BuildContext context) {
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
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
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
            padding: const EdgeInsetsGeometry.fromLTRB(20, 10, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.name, style: h1()),

                    const SizedBox(height: 10),
                    Text('\$${product.price}', style: h3()),
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
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                maximumSize: const Size(150, 50),
                minimumSize: const Size(100, 40),
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
