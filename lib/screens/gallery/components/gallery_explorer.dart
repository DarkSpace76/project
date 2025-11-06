import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:project/screens/gallery/model/image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Widget gallery(List<AppImamge> imgaes) {
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
          child: Image.network(
            imgaes[i].url ?? '',
            fit: BoxFit.fill,
            loadingBuilder:
                (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1),
                    ),
                  );
                },
          ),
        ),
      );
    },
  );
}
