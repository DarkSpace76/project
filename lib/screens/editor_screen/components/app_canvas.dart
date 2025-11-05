import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/screens/editor_screen/models/model_edit.dart';

GlobalKey repaintKey = GlobalKey();

class AppCanvas extends StatefulWidget {
  Color paintColor;
  AppCanvas({super.key, required this.paintColor});

  @override
  _AppCanvasState createState() => _AppCanvasState();
}

class _AppCanvasState extends State<AppCanvas> {
  List<Pen> lines = [];
  List<Offset> pointsDraw = [];
  ui.Image? image;

  Future<ui.Image> importImage(String asset) async {
    final data = await rootBundle.load(asset);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  void initState() {
    super.initState();
    importImage('assets/test.jpg').then((img) {
      setState(() {
        image = img;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        // margin: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
            onPanStart: (_) {
              pointsDraw = [];
              lines.add(Pen(points: pointsDraw, color: widget.paintColor));
            },
            onPanUpdate: (details) {
              setState(() {
                RenderBox box = context.findRenderObject() as RenderBox;
                Offset localPos = box.globalToLocal(details.globalPosition);

                double x = localPos.dx.clamp(0.0, constraints.maxWidth);
                double y = localPos.dy.clamp(0.0, constraints.maxHeight);
                pointsDraw.add(Offset(x, y));
              });
            },
            onPanEnd: (_) {
              pointsDraw.add(Offset.infinite);
            },
            child: RepaintBoundary(
              key: repaintKey,
              child: CustomPaint(
                painter: Painter(lines, image: image),
                size: Size.infinite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Painter extends CustomPainter {
  final List<Pen> lines;
  final ui.Image? image;

  Painter(this.lines, {this.image});

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      // Рисуем изображение на всю площадь canvas
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.width, size.height),
        image: image!,
        fit: BoxFit.cover,
      );
    }

    for (var line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < line.points.length - 1; i++) {
        if (line.points[i] != Offset.infinite &&
            line.points[i + 1] != Offset.infinite) {
          canvas.drawLine(line.points[i], line.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant Painter oldDelegate) => true;
}
