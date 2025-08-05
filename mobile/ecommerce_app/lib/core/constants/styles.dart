import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

TextStyle h1() {
  return GoogleFonts.poppins(
    color: CustomColor.black,
    fontWeight: FontWeight.w600,
    fontSize: 24,
  );
}

TextStyle h2() {
  return GoogleFonts.poppins(
    color: CustomColor.grey,
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );
}

TextStyle h3() {
  return GoogleFonts.sora(
    color: CustomColor.grey,
    fontWeight: FontWeight.w400,
    fontSize: 15,
  );
}

TextStyle h3Black() {
  return GoogleFonts.poppins(
    color: CustomColor.black,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );
}

TextStyle p() {
  return GoogleFonts.poppins(
    color: CustomColor.grey,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );
}

TextStyle date() {
  return GoogleFonts.syne(
    color: CustomColor.grey,
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );
}
