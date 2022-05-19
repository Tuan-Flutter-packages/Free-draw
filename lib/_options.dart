import 'package:flutter/material.dart';

import '_shape.dart';

class PaintOptions {
  PaintOptions({
    this.color = Colors.black,
    this.lineWidth = 1.0,
    this.drawType = DrawShapeType.free,
  });
  Color color;
  double lineWidth;
  DrawShapeType drawType;

  PaintOptions copyWith(
      {Color? color, double? lineWidth, DrawShapeType? drawType}) {
    return PaintOptions(
      color: color ?? this.color,
      lineWidth: lineWidth ?? this.lineWidth,
      drawType: drawType ?? this.drawType,
    );
  }
}
