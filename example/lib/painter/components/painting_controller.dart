
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'painter.dart';
import 'painting.dart';
import 'painting_screenshot.dart';
import 'serilizable_paint.dart';

/// Used with a [PainterWidget] widget to control drawing.
class PainterController extends ChangeNotifier {
  Color _drawColor = new Color.fromARGB(255, 0, 0, 0);
  Color _backgroundColor = new Color.fromARGB(255, 255, 255, 255);
  bool _eraseMode = false;

  double _thickness = 1.0;
  PaintingScreenshot? _cached;

  ValueGetter<Size>? widgetFinish;
  
  late Painter _painter;
  Painter get painter => _painter;

  /// Creates a new instance for the use in a [PainterWidget] widget.
  PainterController([Painting? painting]) {
    _painter = Painter(painting, repaint: this);
  }

  /// Returns true if nothing has been drawn yet.
  bool get isEmpty => _painter.isEmpty;

  /// Returns true if the the [PainterController] is currently in erase mode,
  /// false otherwise.
  bool get eraseMode => _eraseMode;

  /// If set to true, erase mode is enabled, until this is called again with
  /// false to disable erase mode.
  set eraseMode(bool enabled) {
    _eraseMode = enabled;
    _updatePaint();
  }

  /// Retrieves the current draw color.
  Color get drawColor => _drawColor;

  /// Sets the draw color.
  set drawColor(Color color) {
    _drawColor = color;
    _updatePaint();
  }

  /// Retrieves the current background color.
  Color get backgroundColor => _backgroundColor;

  /// Updates the background color.
  set backgroundColor(Color color) {
    _backgroundColor = color;
    _updatePaint();
  }

  /// Returns the current thickness that is used for drawing.
  double get thickness => _thickness;

  /// Sets the draw thickness..
  set thickness(double t) {
    _thickness = t;
    _updatePaint();
  }

  void _updatePaint() {
    SerializablePaint paint = new SerializablePaint();
    if (_eraseMode) {
      paint.blendMode = BlendMode.clear;
      paint.color = Color.fromARGB(0, 255, 0, 0);
    } else {
      paint.color = drawColor;
      paint.blendMode = BlendMode.srcOver;
    }
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = thickness;
    _painter.drawPaint = paint;
    _painter.setBackgroundColor(backgroundColor);
    notifyListeners();
  }

  void updatePainting(){
    notifyListeners();
  }

  /// Undoes the last drawing action (but not a background color change).
  /// If the picture is already finished, this is a no-op and does nothing.
  void undo() {
    if (!isFinished()) {
      _painter.undo();
      notifyListeners();
    }
  }

  /// Deletes all drawing actions, but does not affect the background.
  /// If the picture is already finished, this is a no-op and does nothing.
  void clear() {
    if (!isFinished()) {
      _painter.clear();
      notifyListeners();
    }
  }

  /// Finishes drawing and returns the rendered [PaintingScreenshot] of the drawing.
  /// The drawing is cached and on subsequent calls to this method, the cached
  /// drawing is returned.
  ///
  /// This might throw a [StateError] if this PainterController is not attached
  /// to a widget, or the associated widget's [Size.isEmpty].
  PaintingScreenshot finish() {
    if (!isFinished()) {
      if (widgetFinish != null) {
        _cached = _render(widgetFinish!());
      } else {
        throw new StateError(
            'Called finish on a PainterController that was not connected to a widget yet!');
      }
    }
    return _cached!;
  }

  PaintingScreenshot _render(Size size) {
    if (size.isEmpty) {
      throw new StateError('Tried to render a picture with an invalid size!');
    } else {
      PictureRecorder recorder = new PictureRecorder();
      Canvas canvas = new Canvas(recorder);
      _painter.draw(canvas, size);
      return new PaintingScreenshot(
          recorder.endRecording(), size.width.floor(), size.height.floor());
    }
  }

  /// Returns true if this drawing is finished.
  ///
  /// Trying to modify a finished drawing is a no-op.
  bool isFinished() {
    return _cached != null;
  }

  /// Returns serialized painting map that is used to be used to store the painting [Painter.painting] 
  Map<String, dynamic> getPaintingMap() => _painter.painting.toMap();

  /// Returns serialized json of painting
  String getPaintingJson() => _painter.painting.toJson();

  void loadPainting(Map<String, dynamic> paintingMap) {
    _painter.painting = Painting.fromMap(paintingMap);
  }
}
