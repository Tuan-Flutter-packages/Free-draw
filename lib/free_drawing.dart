library free_drawing;

import 'package:flutter/material.dart';

import '_canvas.dart';
import '_shape.dart';

export './_canvas.dart';
export './_painter.dart';
export './_shape.dart';

part './_controller.dart';

class FreeDrawing extends StatefulWidget {
  const FreeDrawing({Key? key, this.controller}) : super(key: key);
  final FreeDrawingController? controller;

  @override
  State<FreeDrawing> createState() => _FreeDrawingState();

  static _FreeDrawingState of(BuildContext context) {
    return context.findAncestorStateOfType<_FreeDrawingState>()!;
  }
}

class _FreeDrawingState extends State<FreeDrawing> {
  final canvasController = TransformationController();
  late final FreeDrawingController controller;

  @override
  void initState() {
    controller = widget.controller ?? FreeDrawingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onInteractionStart(details) => controller._drawStart();

  void onInteractionUpdate(details) =>
      controller._drawUpdate(canvasController.toScene(details.localFocalPoint));

  void onInteractionEnd(details) => controller._drawEnd();

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: canvasController,
      onInteractionStart: onInteractionStart,
      onInteractionUpdate: onInteractionUpdate,
      onInteractionEnd: onInteractionEnd,
      scaleEnabled: false,
      panEnabled: false,
      // constrained: false,
      // maxScale: 5,
      // minScale: 0.1,
      child: ValueListenableBuilder<DrawShape?>(
        valueListenable: controller._drawNotifier,
        builder: (context, draw, child) {
          return ValueListenableBuilder<List<DrawShape>>(
            valueListenable: controller._shapesNotifier,
            builder: (context, shapes, child) {
              final shapeWithDraw = [...shapes];
              if (draw != null) shapeWithDraw.add(draw);
              return DrawingCanvas(shapes: shapeWithDraw);
            },
          );
        },
      ),
    );
  }
}
