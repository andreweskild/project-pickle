import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/tool.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas.dart';

class LineTool extends Tool {
  LineTool(
    this._context,
    this._canvas
  );


  final BuildContext _context;
  final PixelCanvas _canvas;

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
      _canvas.addPreviewPixel(snappedX, snappedY, Colors.purple);
    }
    else {
      _endPoint = new Offset(snappedX, snappedY);
      _canvas.addPreviewPixelsFromLine(_startPoint, _endPoint, Colors.purple);
    }
  }

  @override
  void handlePanUpdate(DragUpdateDetails details) {
    _canvas.resetPreview();
    
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
    _canvas.addPreviewPixelsFromLine(_startPoint, _endPoint, Colors.green);
  }

  @override
  void handlePanEnd(DragEndDetails details) {
    _canvas.finalizePreview();
    resetLinePoints();
  }

  @override
  void handleTapUp(TapUpDetails details) {
    if(_endPoint != null) {
      _canvas.finalizePreview();
      resetLinePoints();
    }
  }

  void resetLinePoints() {
    _startPoint = null;
    _endPoint = null;
  }

}