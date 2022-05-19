part of './free_drawing.dart';

class FreeDrawingController extends ChangeNotifier {
  FreeDrawingController({List<DrawShape>? initShapes}) {
    if (initShapes != null) _shapesNotifier.value = initShapes;
    _shapesCacheNotifier.addListener(notifyListeners);
    _shapesNotifier.addListener(notifyListeners);
    _drawNotifier.addListener(notifyListeners);
  }

  /// ValueNotifier of cache shape, all shape that undo stored here, when place
  /// new DrawShape this cache will clear.
  final _shapesCacheNotifier = ValueNotifier<List<DrawShape>>([]);

  /// ValueNotifier of shapes, all shapes stored here
  final _shapesNotifier = ValueNotifier<List<DrawShape>>([]);

  /// ValueNotifier of currently DrawShape
  final _drawNotifier = ValueNotifier<DrawShape?>(null);

  /// Clear all shapes and cache
  void clear() {
    _drawNotifier.value = null;
    _shapesNotifier.value = [];
    _shapesCacheNotifier.value = [];
  }

  /// Check we can redo or not, actualy check undo cache have not empty
  bool get redoEnable => _shapesCacheNotifier.value.isNotEmpty;

  /// Back from last undo
  void redo() {
    if (!redoEnable) return;
    final shape = _shapesCacheNotifier.value.last;
    _shapesNotifier.value = [..._shapesNotifier.value, shape];
    _shapesCacheNotifier.value = [..._shapesCacheNotifier.value]..removeLast();
  }

  /// Check we can undo or not, actualy check shapes have not empty
  bool get undoEnable => _shapesNotifier.value.isNotEmpty;

  /// Back from last Draw
  void undo() {
    if (!undoEnable) return;
    final shape = _shapesNotifier.value.last;
    _shapesNotifier.value = [..._shapesNotifier.value]..removeLast();
    _shapesCacheNotifier.value = [..._shapesCacheNotifier.value, shape];
  }

  /// OnInteraction start, create new empty DrawShape
  void _drawStart() => _drawNotifier.value = DrawShape();

  /// OnInteraction update, add new point to DrawShape
  void _drawUpdate(Offset point) => _drawNotifier.value =
      DrawShape(points: [..._drawNotifier.value?.points ?? [], point]);

  /// OnInteraction end, add current DrawShape to shapes, clear cache,...
  void _drawEnd() {
    var newShapes = [..._shapesNotifier.value];
    if (_drawNotifier.value != null && _drawNotifier.value!.points.isNotEmpty) {
      newShapes.add(_drawNotifier.value!);
    }
    _shapesCacheNotifier.value = [];
    _shapesNotifier.value = newShapes;
    _drawNotifier.value = null;
  }

  /// Dispose,...
  @override
  void dispose() {
    _shapesCacheNotifier.removeListener(notifyListeners);
    _shapesNotifier.removeListener(notifyListeners);
    _drawNotifier.removeListener(notifyListeners);
    _shapesCacheNotifier.dispose();
    _shapesNotifier.dispose();
    _drawNotifier.dispose();
    super.dispose();
  }
}
