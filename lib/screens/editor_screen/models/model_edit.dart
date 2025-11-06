import 'dart:ui';

import 'package:flutter/material.dart';

class PointsArray {
  List<Offset> points;
  Color color;
  double brushSize;

  PointsArray({
    required this.points,
    required this.brushSize,
    required this.color,
  });
}

class Brush {
  static late Brush instance;

  bool isErase = false;
  Color _currentColor = Colors.red;
  double _brushSize = 5.0;

  Color get color => isErase ? Colors.white : _currentColor;
  double get size => _brushSize;

  Brush() {
    instance = this;
  }

  void brush() => isErase = false;

  void erase() => isErase = true;

  void setColor(Color? color) => this._currentColor = color!;

  void setSize(double? size) => this._brushSize = size!;
}
