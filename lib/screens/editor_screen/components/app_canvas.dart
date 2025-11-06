import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/screens/editor_screen/models/model_edit.dart';
import 'package:project/utils/utils.dart';

GlobalKey repaintKey = GlobalKey();

class AppCanvas extends StatefulWidget {
  AppCanvas({super.key});

  @override
  _AppCanvasState createState() => _AppCanvasState();
}

class _AppCanvasState extends State<AppCanvas> {
  List<PointsArray> lines = [];
  List<Offset> pointsDraw = [];
  ui.Image? image;

  @override
  void initState() {
    super.initState();
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
              lines.add(
                PointsArray(
                  points: pointsDraw,
                  color: Brush.instance.color,
                  brushSize: Brush.instance.size,
                ),
              );
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
  final List<PointsArray> points;
  final ui.Image? image;

  Painter(this.points, {this.image});

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

    for (var point in points) {
      final paint = Paint()
        ..color = point.color
        ..strokeWidth = point.brushSize
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < point.points.length - 1; i++) {
        if (point.points[i] != Offset.infinite &&
            point.points[i + 1] != Offset.infinite) {
          canvas.drawLine(point.points[i], point.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant Painter oldDelegate) => true;
}
