import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/tool.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas.dart';

class PencilTool extends Tool {
  PencilTool(
    this._context,
    this._controller
  );

  final BuildContext _context;
  final PixelCanvas _controller;

  Offset _lastPoint;


  @override
  void handlePanDown(DragDownDetails details) {
    RenderBox box = _context.findRenderObject();
    var pos = box.globalToLocal(details.globalPosition);
    double snappedX = pos.dx.floorToDouble();
    double snappedY = pos.dy.floorToDouble();
    _controller.setPixel(snappedX, snappedY, Colors.red);
  }

  @override
  void handlePanUpdate(DragUpdateDetails details) {
    RenderBox box = _context.findRenderObject();
    var pos = box.globalToLocal(details.globalPosition);
    double snappedX = pos.dx.floorToDouble();
    double snappedY = pos.dy.floorToDouble();
    
    if(_lastPoint != null) {
      if((_lastPoint.dx - snappedX).abs() > 1 || 
        (_lastPoint.dy - snappedY).abs() > 1) {
          _controller.setPixelsFromLine(
            _lastPoint,
            new Offset(snappedX, snappedY), 
            Colors.red
          );
      }
      else {
        _controller.setPixel(snappedX, snappedY, Colors.blue);
      }
      _lastPoint = new Offset(snappedX, snappedY);
    }
    else {
      _controller.setPixel(snappedX, snappedY, Colors.green);
      _lastPoint = new Offset(snappedX, snappedY);
    }
  }

  @override
  void handlePanEnd(DragEndDetails details) {
    _lastPoint = null;
  }

  @override
  void handleTapUp(TapUpDetails details) {
    
  }

}