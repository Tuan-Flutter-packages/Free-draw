import 'package:flutter/material.dart';

import '_options.dart';

enum DrawShapeType { free, dot }

extension on DrawShapeType {
  String get name => toString();
}

class DrawShape {
  DrawShape({
    List<Offset>? points,
    PaintOptions? drawOptions,
  }) {
    pointsNotifier = ValueNotifier<List<Offset>>([]);
    this.drawOptions = drawOptions ?? PaintOptions();
    paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..color = this.drawOptions.color
      ..strokeWidth = this.drawOptions.lineWidth
      ..style = PaintingStyle.stroke;

    if (points != null) pointsNotifier.value = points;
  }

  late final ValueNotifier<List<Offset>> pointsNotifier;
  late final Paint paint;
  late final PaintOptions drawOptions;

  List<Offset> get points => pointsNotifier.value;

  void add(Offset point) => pointsNotifier.value = [...points, point];

  DrawShape copyWith({List<Offset>? points, PaintOptions? drawOptions}) {
    return DrawShape(
      points: points ?? this.points,
      drawOptions: drawOptions ?? this.drawOptions,
    );
  }

  @override
  String toString() => "(${points.length}) $points";
}
