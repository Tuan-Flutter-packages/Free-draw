import 'package:flutter/material.dart';
import 'package:free_drawing/free_drawing.dart';

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.shape) : super(repaint: shape.pointsNotifier);
  final DrawShape shape;

  List<Offset> get points => shape.points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isNotEmpty) {
      final path = Path();

      path.moveTo(points[0].dx, points[0].dy);

      for (int f = 1; f < points.length; f++) {
        path.lineTo(points[f].dx, points[f].dy);
      }

      canvas.drawPath(path, shape.paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
