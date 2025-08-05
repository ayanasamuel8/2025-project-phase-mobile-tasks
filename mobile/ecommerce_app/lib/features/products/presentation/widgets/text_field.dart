import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/colors.dart';

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
      const SizedBox(height: 8),
      TextField(
        controller: controller, // Uses the passed controller
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: color,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: border
                ? const BorderSide(color: CustomColor.grey, width: 2.0)
                : BorderSide.none,
          ),
        ),
      ),
    ],
  );
}
