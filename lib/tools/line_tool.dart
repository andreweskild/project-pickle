import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'tool.dart';
import '../data_objects/pixel_controller.dart';

class LineTool extends Tool {
  LineTool(
    this._context,
    this._controller
  );


  final BuildContext _context;
  final PixelController _controller;

  Offset _startPoint;
  Offset _endPoint;

  @override
  void handlePanDown(DragDownDetails details) {
    RenderBox box = _context.findRenderObject();
    var pos = box.globalToLocal(details.globalPosition);
    double snappedX = pos.dx.floorToDouble();
    double snappedY = pos.dy.floorToDouble();
    
    if (_startPoint == null) {
      _startPoint = new Offset(snappedX, snappedY);
      _controller.setPixel(snappedX, snappedY, Colors.purple);
    }
    else {
      _endPoint = new Offset(snappedX, snappedY);
      _controller.setPixelsFromLine(_startPoint, _endPoint, Colors.purple);
    }
  }

  @override
  void handlePanUpdate(DragUpdateDetails details) {
    RenderBox box = _context.findRenderObject();
    var pos = box.globalToLocal(details.globalPosition);
    double snappedX = pos.dx.floorToDouble();
    double snappedY = pos.dy.floorToDouble();
    if(_startPoint == null) {
      _startPoint = new Offset(snappedX, snappedY);
    }
    else {
      _endPoint = new Offset(snappedX, snappedY);
    }
    _controller.setPixelsFromLine(_startPoint, _endPoint, Colors.green);
  }

  @override
  void handlePanEnd(DragEndDetails details) {
    _controller.finalizePixels();
    resetLinePoints();
  }

  @override
  void handleTapUp(TapUpDetails details) {
    if(_endPoint != null) {
      _controller.finalizePixels();
      resetLinePoints();
    }
  }

  void resetLinePoints() {
    _startPoint = null;
    _endPoint = null;
  }

}