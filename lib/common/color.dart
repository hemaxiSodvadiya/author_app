import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static Color bgColor = Color(0xffe2e2ff);
  static Color mainColor = Color(0xff000633);
  static Color accentColor = Color(0xff0065ff);

  static List<Color> cardsColor = [
    Colors.white,
    Colors.red.shade100,
    Colors.pink.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.blueGrey.shade100,
  ];

  static TextStyle mainTitle =
      GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold);
  static TextStyle mainContext =
      GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500);
}
