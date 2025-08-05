import 'package:flutter/material.dart';

import '../../../../core/constants/styles.dart';
import '../../domain/entities/product.dart';

Widget productWidget(Product product) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: InkWell(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(product.imageUrl),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsetsGeometry.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product.name, style: h1()),
                const SizedBox(height: 10.0),
                Text('\$${product.price}', style: h2()),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
