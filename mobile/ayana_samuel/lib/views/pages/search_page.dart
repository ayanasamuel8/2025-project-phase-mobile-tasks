import 'package:basic_ecommerce/constants/colors.dart';
import 'package:basic_ecommerce/views/widgets/price_range_slider.dart';
import 'package:basic_ecommerce/views/widgets/products_card.dart';
import 'package:basic_ecommerce/views/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool showFilters = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Search Product',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Top Sticky Search Bar & Filter Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color: CustomColor.grey),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: CustomColor.grey,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: CustomColor.grey,
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.arrow_forward, color: Colors.indigo),
                        onPressed: () {
                          // Handle search action
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: showFilters ? Colors.indigo : Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.indigo, width: 2.0),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: showFilters ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        showFilters = !showFilters;
                      });
                    },
                  ),
                ),
              ],
            ),

            // 🔄 Scrollable Search Results
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // List of search results
                    ...cardBuilder(context),
                  ],
                ),
              ),
            ),

            if (showFilters)
              Container(
                padding: EdgeInsets.all(12),
                // color: Colors.grey[200],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category picker, price range, etc.
                    SizedBox(height: 8),
                    buildTextField('category', Colors.white, border: true),
                    SizedBox(height: 8),
                    Text(
                      'Price',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    PriceRangeScreen(),
                    SizedBox(height: 8),
                    Theme(
                      data: Theme.of(context).copyWith(useMaterial3: false),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Apply filters
                              },
                              child: Text("APPLY"),
                            ),
                          ),
                        ],
                      ),
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
