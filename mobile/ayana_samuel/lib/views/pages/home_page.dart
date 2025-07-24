import 'package:basic_ecommerce/views/widgets/products_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/icon.dart';
import '../../constants/colors.dart';

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
              child: SizedBox(height: 50, width: 50),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'July 14, 2023',
                  style: GoogleFonts.syne(
                    fontWeight: FontWeight.w500,
                    color: CustomColor.grey,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Hello,',
                      style: GoogleFonts.sora(
                        color: CustomColor.darkGrey,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      'Yohannes',
                      style: GoogleFonts.sora(
                        color: CustomColor.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            customIcon(Icons.notifications_none, true, context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Products',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: CustomColor.black,
                      fontSize: 24,
                    ),
                  ),
                  customIcon(Icons.search, false, context),
                ],
              ),
              ...cardBuilder(context),
            ],
          ),
        ),
      ),
    );
  }
}
