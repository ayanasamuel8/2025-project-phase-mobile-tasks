import 'package:basic_ecommerce/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// lib/views/widgets/text_field.dart (modification)
Widget buildTextField(
  String label,
  Color? color, {
  int maxLines = 1,
  TextEditingController? controller,
  bool border = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 8),
      TextField(
        controller: controller, // Use the passed controller
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: color,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: border
                ? BorderSide(color: CustomColor.grey, width: 2.0)
                : BorderSide.none,
          ),
        ),
      ),
    ],
  );
}
