import 'dart:ui';

import 'package:flutter/material.dart';

Widget gallery(List<String> imgaes) {
  return GridView.builder(
    padding: EdgeInsets.only(top: 16),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
    ),
    itemCount: imgaes.length,
    itemBuilder: (ctx, i) {
      return Container(
        width: 156,
        height: 156,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(16),
          child: Image.asset(imgaes[i], fit: BoxFit.fill),
        ),
      );
    },
  );
}
