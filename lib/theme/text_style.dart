import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static var bodyLgMedium;

  static TextStyle get headingxl {
    return GoogleFonts.inter(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
  }

  static TextStyle get headingMd {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }

  static TextStyle get headingSm {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }

  // Body styles (Body/lg)
  static TextStyle get bodyLg {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
  }

  static TextStyle get bodyLgSemiBold {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
  }
}
