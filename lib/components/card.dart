import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:project/styles/colors.dart';

const double _heigthCard = 85;

Widget card({
  TextEditingController? controller,
  required String title,
  required String hint,
  bool obscureText = false,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
}) {
  InputDecoration inputDecorator() {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: hintColors),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: cardInputColor, width: 1),
      ),
      isDense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget input() {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: '*',
      style: TextStyle(color: cardTextColor),
      decoration: inputDecorator(),
      keyboardType: keyboardType,

      validator: validator,
    );
  }

  return Container(
    height: _heigthCard,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: BoxBorder.all(
        width: 0.5,
        color: Color.fromRGBO(135, 133, 143, 1),
      ),
    ),
    child: Stack(
      children: [
        _bgBure(),
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 12, color: cardTextColor)),
              const SizedBox(height: 6),
              input(),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _bgBure() {
  return ClipRRect(
    child: ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 23, sigmaY: 23),
      child: Container(
        height: _heigthCard,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          boxShadow: [
            const BoxShadow(
              color: shadowdColor1,
              spreadRadius: 100.0,
              blurRadius: 100.0,
            ),
            const BoxShadow(
              color: shadowdColor2,
              spreadRadius: -12.0,
              blurRadius: 12.0,
            ),
          ],
        ),
      ),
    ),
  );
}
