import 'package:basic_ecommerce/constants/colors.dart';
import 'package:basic_ecommerce/views/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});
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
          icon: Icon(Icons.arrow_back_ios, color: Colors.indigo),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              //placeholder for product image
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: MediaQuery.of(context).size.width * 0.43 - 25,
                  child: IconButton(
                    icon: Image.asset(
                      'images/image_icon.png',
                      width: 50,
                      height: 50,
                    ),
                    onPressed: () {
                      // Handle image selection
                    },
                  ),
                ),
                Positioned(
                  top: 120,
                  left: MediaQuery.of(context).size.width * 0.39 - 25,
                  child: Text(
                    'Upload Image',
                    style: TextStyle(color: CustomColor.black, fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            buildTextField('name', Colors.grey[300]),
            SizedBox(height: 20),
            buildTextField('category', Colors.grey[300]),
            SizedBox(height: 20),
            buildTextField('price', Colors.grey[300]),
            SizedBox(height: 20),
            buildTextField('description', Colors.grey[300], maxLines: 5),
            SizedBox(height: 20),
            Theme(
              data: Theme.of(context).copyWith(useMaterial3: false),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Add'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
