import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/styles/colors.dart';

Widget _bgAppBar() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 23, sigmaY: 23),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: [
            const BoxShadow(
              color: appbarShadowdColor1,
              spreadRadius: 100.0,
              blurRadius: 100.0,
            ),
            const BoxShadow(
              color: Color.fromARGB(131, 18, 7, 23),
              spreadRadius: -14.0,
              blurRadius: 14.0,
            ),
          ],
        ),
      ),
    ),
  );
}

AppBar customAppBar({
  String? caption,
  String? leadingIcon,
  String? confirm,
  Function()? onLeadingPress,
  Function()? onConfirmPress,
}) {
  return AppBar(
    leading: leadingIcon != null
        ? IconButton(
            onPressed: onLeadingPress,
            icon: SvgPicture.asset(leadingIcon, width: 24, height: 24),
          )
        : null,
    actions: confirm != null
        ? [
            IconButton(
              onPressed: onConfirmPress,
              icon: SvgPicture.asset(confirm, width: 24, height: 24),
            ),
          ]
        : null,
    title: Text(
      caption ?? '',
      style: GoogleFonts.roboto(
        color: appbarColorTitle,
        fontWeight: FontWeight.w500,
      ),
    ),
    flexibleSpace: _bgAppBar(),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
