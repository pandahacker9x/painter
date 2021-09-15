import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'painting.dart';
import 'painting_path.dart';
import 'serializable_path.dart';
import 'serilizable_paint.dart';

class Painter extends CustomPainter {
  Painting painting;

  SerializablePaint drawPaint;
  
  SerializablePaint get backgroundPaint => painting.backgroundPaint;
  set backgroundPaint(SerializablePaint bgPaint) => painting.backgroundPaint = bgPaint;

  bool _inDrag;

  Painter(Painting? painting, {Listenable? repaint})
      : this.painting = painting ?? Painting(),
        _inDrag = false,
        drawPaint = new SerializablePaint()
          ..color = Colors.black
          ..strokeWidth = 1.0
          ..style = PaintingStyle.fill,
        super(repaint: repaint);

  bool get isEmpty =>
      painting.paths.isEmpty || (painting.paths.length == 1 && _inDrag);

  @override
  void paint(Canvas canvas, Size size) {
    draw(canvas, size);
  }

  void setBackgroundColor(Color backgroundColor) {
    backgroundPaint.color = backgroundColor;
  }

  void undo() {
    if (!_inDrag) {
      painting.paths.removeLast();
    }
  }

  void clear() {
    if (!_inDrag) {
      painting.paths.clear();
    }
  }

  void add(Offset startPoint) {
    if (!_inDrag) {
      _inDrag = true;
      final path = new SerializablePath();
      path.moveTo(startPoint.dx, startPoint.dy);
      painting.paths.add(PaintingPath(path, drawPaint));
    }
  }

  void updateCurrent(Offset nextPoint) {
    if (_inDrag) {
      SerializablePath path = painting.paths.last.path;
      path.lineTo(nextPoint.dx, nextPoint.dy);
    }
  }

  void endCurrent() {
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    for (PaintingPath paintingPath in painting.paths) {
      canvas.drawPath(paintingPath.path, paintingPath.paint);
    }
    canvas.drawRect(
        new Rect.fromLTWH(0.0, 0.0, size.width, size.height), backgroundPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return true;
  }
}
