library free_drawing;

import 'package:flutter/material.dart';

import '_canvas.dart';
import '_options.dart';
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

  bool get lockDraw => controller._canvasLockNotifier.value;

  @override
  void initState() {
    controller = widget.controller ?? FreeDrawingController();
    controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(() => setState(() {}));
    controller.dispose();
    super.dispose();
  }

  void onInteractionStart(details) {
    if (lockDraw) return;
    controller._drawStart(canvasController.toScene(details.localFocalPoint));
  }

  void onInteractionUpdate(details) {
    if (lockDraw) return;
    controller._drawUpdate(canvasController.toScene(details.localFocalPoint));
  }

  void onInteractionEnd(details) {
    if (lockDraw) return;
    controller._drawEnd();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: canvasController,
      onInteractionStart: onInteractionStart,
      onInteractionUpdate: onInteractionUpdate,
      onInteractionEnd: onInteractionEnd,
      scaleEnabled: lockDraw,
      panEnabled: lockDraw,
      // constrained: false,
      maxScale: 5,
      minScale: 1,
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

mixin FreeDrawingToolBarMixin<T extends StatefulWidget> on State<T> {
  FreeDrawingController get controller;
  PaintOptions get options => controller.paintOption;

  void updatePaint(PaintOptions options) =>
      controller._paintNotifier.value = options;

  @override
  void initState() {
    controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(() => setState(() {}));
    super.dispose();
  }
}

class FreeDrawingToolBar extends StatefulWidget {
  const FreeDrawingToolBar({Key? key, required this.controller})
      : super(key: key);
  final FreeDrawingController controller;

  @override
  State<FreeDrawingToolBar> createState() => _FreeDrawingToolBarState();
}

class _FreeDrawingToolBarState extends State<FreeDrawingToolBar>
    with FreeDrawingToolBarMixin {
  @override
  FreeDrawingController get controller => widget.controller;

  void openPaintEditor() async {
    final newPaintOption = await showDialog(
      context: context,
      builder: (context) {
        const colors = <Color>[
          Colors.black,
          Colors.green,
          Colors.blue,
          Colors.red,
          Colors.yellow,
        ];
        PaintOptions optionsCopy = options.copyWith();
        save() => Navigator.of(context).pop(optionsCopy);

        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Size: '),
                  Slider(
                    label: 'Line with (${optionsCopy.lineWidth})',
                    value: optionsCopy.lineWidth,
                    divisions: 10,
                    min: 1,
                    max: 6,
                    onChanged: (w) => setState(() => optionsCopy.lineWidth = w),
                  ),
                  Row(
                    children: [
                      const Text('Type: '),
                      Expanded(
                        child: DropdownButton<DrawShapeType>(
                          value: optionsCopy.drawType,
                          items: DrawShapeType.values.map((e) {
                            return DropdownMenuItem<DrawShapeType>(
                              value: e,
                              child: Text(e.name),
                            );
                          }).toList(),
                          onChanged: (e) =>
                              setState(() => optionsCopy.drawType = e!),
                        ),
                      ),
                    ],
                  ),
                  const Text('Color: '),
                  Wrap(
                    children: colors.map((color) {
                      final selectedColor = color == optionsCopy.color;
                      return GestureDetector(
                        onTap: () => setState(() => optionsCopy.color = color),
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            color: color,
                          ),
                          child: selectedColor
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(onPressed: save, child: const Text('Save')),
                ],
              );
            },
          ),
        );
      },
    );
    if (newPaintOption != null) updatePaint(newPaintOption);
  }

  @override
  Widget build(BuildContext context) {
    final lockDraw = controller._canvasLockNotifier.value;
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(border: Border.all()),
      child: Wrap(
        runSpacing: 4,
        spacing: 4,
        children: [
          IconButton(
            onPressed: controller.clear,
            icon: const Icon(Icons.clear_rounded),
          ),
          IconButton(
            onPressed: () => controller._canvasLockNotifier.value = !lockDraw,
            icon: lockDraw
                ? const Icon(Icons.edit_off_rounded)
                : const Icon(Icons.edit_rounded),
          ),
          IconButton(
            onPressed: controller.undoEnable ? controller.undo : null,
            icon: const Icon(Icons.skip_previous_rounded),
          ),
          IconButton(
            onPressed: controller.redoEnable ? controller.redo : null,
            icon: const Icon(Icons.skip_next_rounded),
          ),
          IconButton(
            onPressed: openPaintEditor,
            icon: const Icon(Icons.settings_suggest_rounded),
          ),
        ],
      ),
    );
  }
}
