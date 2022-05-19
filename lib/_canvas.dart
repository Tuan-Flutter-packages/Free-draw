import 'package:flutter/material.dart';

import 'free_drawing.dart';

/// Widget that drawing canvas (stack of Shapes)
class DrawingCanvas extends StatelessWidget {
  const DrawingCanvas({Key? key, required this.shapes}) : super(key: key);
  final List<DrawShape> shapes;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: List.generate(
        shapes.length,
        (i) => DrawingShape(shape: shapes[i]),
        growable: true,
      ),
    );
  }
}

/// Widget that drawing shape (CustomPaint)
class DrawingShape extends StatelessWidget {
  const DrawingShape({Key? key, required this.shape}) : super(key: key);
  final DrawShape shape;
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        willChange: true,
        foregroundPainter: DrawingPainter(shape),
      ),
    );
  }
}
