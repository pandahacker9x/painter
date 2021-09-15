/// Provides a widget and an associated controller for simple painting using touch.
library painter;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'components/painter.dart';
import 'components/painting_controller.dart';

/// A very simple widget that supports drawing using touch.
class PainterWidget extends StatefulWidget {
  final PainterController controller;

  /// Creates an instance of this widget that operates on top of the supplied [PainterController].
  PainterWidget(PainterController painterController)
      : this.controller = painterController,
        super(key: new ValueKey<PainterController>(painterController));

  @override
  _PainterWidgetState createState() => new _PainterWidgetState();
}

class _PainterWidgetState extends State<PainterWidget> {
  bool _finished = false;
  Painter get _painter => widget.controller.painter;

  @override
  void initState() {
    super.initState();
    widget.controller.widgetFinish = _finish;
  }

  Size _finish() {
    setState(() {
      _finished = true;
    });
    return context.size ?? const Size(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext context, Widget? child) {
        return new CustomPaint(
          willChange: true,
          painter: _painter,
        );
      },
    );
    child = new ClipRect(child: child);
    if (!_finished) {
      child = new GestureDetector(
        child: child,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
      );
    }
    return new Container(
      child: child,
      width: double.infinity,
      height: double.infinity,
    );
  }

  void _onPanStart(DragStartDetails start) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(start.globalPosition);
    _painter.add(pos);
    widget.controller.updatePainting();
  }

  void _onPanUpdate(DragUpdateDetails update) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);
    _painter.updateCurrent(pos);
    widget.controller.updatePainting();
  }

  void _onPanEnd(DragEndDetails end) {
    _painter.endCurrent();
    widget.controller.updatePainting();
  }
}

