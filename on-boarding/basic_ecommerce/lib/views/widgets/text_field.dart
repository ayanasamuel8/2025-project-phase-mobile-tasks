import 'package:basic_ecommerce/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildTextField(
  String label,
  Color? color, {
  int maxLines = 1,
  bool border = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 10),
      TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: border
                ? BorderSide(color: Colors.red, width: 2.0)
                : BorderSide.none,
          ),
          filled: true,
          fillColor: color,
          suffixIcon: label.toLowerCase() == 'price'
              ? Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.attach_money, color: Colors.grey[300]),
                )
              : null,
        ),
        maxLines: maxLines,
        keyboardType: label.toLowerCase() == 'price'
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
      ),
    ],
  );
}
