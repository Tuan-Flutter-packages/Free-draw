import 'package:flutter/material.dart';

class DrawShape {
  DrawShape({List<Offset>? points, Paint? paint}) {
    pointsNotifier = ValueNotifier<List<Offset>>([]);
    this.paint = paint ?? DrawShape.defaultPaint;
    if (points != null) pointsNotifier.value = points;
  }

  static Paint defaultPaint = Paint()
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..color = Colors.black
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  late final ValueNotifier<List<Offset>> pointsNotifier;
  late final Paint paint;

  List<Offset> get points => pointsNotifier.value;

  void add(Offset point) => pointsNotifier.value = [...points, point];

  @override
  String toString() => "(${points.length}) $points";
}
