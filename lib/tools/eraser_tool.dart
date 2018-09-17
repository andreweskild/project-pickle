import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/base_drawing_tool.dart';


/// Erases pixels from the currently selected layer.
class EraserTool extends BaseDrawingTool {
  EraserTool(context) : super(context);

  Offset _lastPoint;


  @override
  void onPixelInputUpdate(Offset pos) {
    if ( _lastPoint != null &&
        ((_lastPoint.dx - pos.dx).abs() > 1 || 
        (_lastPoint.dy - pos.dy).abs() > 1)) {
        removePixelLine(_lastPoint, pos);
    }
    else {
      removePixel(pos);
    }
    _lastPoint = pos;
  }

  @override
  void onPixelInputUp() {
    _lastPoint = null;
  }

}