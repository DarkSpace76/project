import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:project/screens/editor_screen/components/app_canvas.dart';

const String _patternValidationEmail = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

String? emailValidator(String? val) {
  if (val == null || val.isEmpty) {
    return 'Введите e-mail';
  }
  if (!RegExp(_patternValidationEmail).hasMatch(val)) {
    return 'Ошибка';
  }
  return null;
}

String? passwordValidator(String? val) {
  if (val == null || val.isEmpty) {
    return 'Введите пароль';
  }
  if (val.length < 8) {
    return 'Длинна пароля не менее 8 символов';
  }
  return null;
}

Future<void> saveToImage() async {
  try {
    RenderRepaintBoundary boundary =
        repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Сохраняем в галерею (или куда угодно)
      final result = await ImageGallerySaver.saveImage(
        pngBytes,
        quality: 100,
        name: "custom_paint_export",
      );
      print("Saved: $result");
    }
  } catch (e) {
    print("Error exporting CustomPaint: $e");
  }
}
