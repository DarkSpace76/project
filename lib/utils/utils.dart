import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:project/screens/editor_screen/components/app_canvas.dart';
import 'package:project/server/notification.dart';
import 'package:project/server/supabase.dart';

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

      SupaBaseService.instance.uploadFile(pngBytes);

      print("Saved: $result");
    }
  } catch (e) {
    print("Error exporting CustomPaint: $e");
  }
}

Future<ui.Image> importImage(String asset) async {
  final data = await rootBundle.load(asset);
  final bytes = data.buffer.asUint8List();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}

Future<void> showNotification() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );
  await NotificationService.notifications.show(
    0,
    'plain title',
    'plain body',
    notificationDetails,
    payload: 'item x',
  );
}
