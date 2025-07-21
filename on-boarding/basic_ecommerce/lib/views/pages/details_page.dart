import 'package:basic_ecommerce/constants/colors.dart';
import 'package:basic_ecommerce/model/product.dart';
import 'package:basic_ecommerce/model/product_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({super.key, this.productId = 0});

  final int productId;

  Container _buildSizeCard(int size) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0.5,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        size.toString(),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  List<Container> _buildSizeList(Product product) {
    return product.sizes.map((size) => _buildSizeCard(size)).toList();
  }

  final products = ProductManager().products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'images/image.jpg',
                width: double.infinity,
                height: 300,
                fit: BoxFit.fitWidth,
              ),
              Positioned(
                top: 10,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.indigo),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[productId].description,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: CustomColor.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              products[productId].title,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                SizedBox(width: 5),
                                Text(
                                  '(${products[productId].rating.toStringAsFixed(1)})',
                                  style: GoogleFonts.sora(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: CustomColor.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              '\$${products[productId].price}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Size:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _buildSizeList(products[productId]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      products[productId].details,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: CustomColor.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(useMaterial3: false),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Update'),
                    style: ElevatedButton.styleFrom(
                      maximumSize: Size(150, 50),
                      minimumSize: Size(100, 40),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
