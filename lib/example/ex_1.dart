import 'package:flutter/material.dart';
import 'package:free_drawing/free_drawing.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final draw = FreeDrawingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                child: FreeDrawing(controller: draw),
              ),
            ),
            StatefulBuilder(
              builder: (context, setState) {
                listener() => setState(() {});
                draw.removeListener(listener);
                draw.addListener(listener);
                return Wrap(
                  runSpacing: 4,
                  spacing: 4,
                  children: [
                    ElevatedButton.icon(
                      onPressed: draw.clear,
                      icon: const Icon(Icons.clear_rounded),
                      label: const Text('Clear'),
                    ),
                    ElevatedButton.icon(
                      onPressed: draw.undoEnable ? draw.undo : null,
                      icon: const Icon(Icons.skip_previous_rounded),
                      label: const Text('Undo'),
                    ),
                    ElevatedButton.icon(
                      onPressed: draw.redoEnable ? draw.redo : null,
                      icon: const Icon(Icons.skip_next_rounded),
                      label: const Text('Redo'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
