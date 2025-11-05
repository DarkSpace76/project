import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget styleTitleForm({required String title}) {
  return Text(
    title,
    style: GoogleFonts.pressStart2p(
      fontSize: 20,
      color: Colors.white,
      shadows: [
        Shadow(
          color: Color.fromRGBO(106, 70, 249, 1),
          blurRadius: 40,
          offset: Offset(0, 0),
        ),
      ],
    ),
  );
}
