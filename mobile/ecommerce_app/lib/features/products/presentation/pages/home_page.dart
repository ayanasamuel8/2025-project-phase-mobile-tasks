import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/styles.dart';
import '../../../../injection_container.dart';
import '../bloc/products_bloc.dart';
import '../widgets/notification_icon.dart';
import '../widgets/product_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        backgroundColor: Colors.white,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const SizedBox(height: 50, width: 50),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('July 14, 2023', style: date()),
                Row(
                  children: [
                    Text('Hello,', style: h3()),
                    const SizedBox(width: 5.0),
                    Text('Yohannes', style: h3Black()),
                  ],
                ),
              ],
            ),
            const Spacer(),
            customIcon(Icons.notifications_none, true, context),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),

      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) =>
              sl<ProductsBloc>()..add(const LoadAllProductsEvent()),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Available Products', style: h1()),
                    customIcon(Icons.search, false, context),
                  ],
                ),
                BlocBuilder<ProductsBloc, ProductsState>(
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return const CircularProgressIndicator();
                    } else if (state is LoadedAllProductsState) {
                      return ListView.builder(
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          return productWidget(product, context);
                        },
                      );
                    } else if (state is ErrorState) {
                      return Text('Failed to load products: ${state.message}');
                    } else {
                      return const Text('An unknown error occurred');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
