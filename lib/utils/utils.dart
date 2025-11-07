import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/screens/editor_screen/components/app_canvas.dart';
import 'package:project/server/supabase.dart';
import 'package:share_plus/share_plus.dart';

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

    String fileName = 'easypaint_${DateTime.now().millisecondsSinceEpoch}.png';

    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();

      await ImageGallerySaver.saveImage(pngBytes, quality: 100, name: fileName);

      SupaBaseService.instance.uploadFile(pngBytes, fileName);
    }
  } catch (e) {
    print(e);
  }
}

Future<ui.Image> importImage(String asset) async {
  final data = await rootBundle.load(asset);
  final bytes = data.buffer.asUint8List();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}

Future<ui.Image?> importImageFromDevice() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 90,
    );

    if (image == null) {
      return null;
    }

    final Uint8List imageBytes = await image.readAsBytes();
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  } catch (e) {
    print('Error select img $e');
    return null;
  }
}

Future<void> shareImage([BuildContext? context]) async {
  try {
    await SchedulerBinding.instance.endOfFrame;
    await Future.delayed(Duration(milliseconds: 200));

    if (repaintKey.currentContext == null) {
      return;
    }

    final RenderObject? renderObject = repaintKey.currentContext!
        .findRenderObject();
    if (renderObject == null || renderObject is! RenderRepaintBoundary) {
      return;
    }

    RenderRepaintBoundary boundary = renderObject;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      return;
    }

    Uint8List dataImage = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final fileName = 'easypaint_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('${tempDir.path}/$fileName');

    await file.writeAsBytes(dataImage);
    print('File saved to ${file.path}');

    if (!await file.exists()) {
      return;
    }
    final absolutePath = file.absolute.path;

    if (!await file.exists()) {
      return;
    }

    final xFile = XFile(absolutePath, mimeType: 'image/png', name: fileName);

    ShareResult? result;

    try {
      Rect? sharePositionRect;
      if (context != null) {
        try {
          final RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null && box.hasSize) {
            final Offset position = box.localToGlobal(Offset.zero);
            final Size size = box.size;
            sharePositionRect = Rect.fromLTWH(
              position.dx,
              position.dy,
              size.width,
              size.height,
            );
            print('Share  $sharePositionRect');
          }
        } catch (e) {
          print(e);
        }
      }

      if (sharePositionRect != null) {
        result = await Share.shareXFiles(
          [xFile],
          text: 'Easy Paint',
          sharePositionOrigin: sharePositionRect,
        );
      } else {
        try {
          result = await Share.shareXFiles([xFile], text: 'Easy Paint');
        } catch (e) {
          print('Share failed  $e');
          result = await Share.shareXFiles(
            [xFile],
            text: 'Easy Paint',
            sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  } catch (e) {
    print(e);
  }
}
