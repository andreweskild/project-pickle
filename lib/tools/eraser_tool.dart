import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/drawing_tool.dart';

class EraserTool extends DrawingTool {
  EraserTool(context) : super(context);

  Offset _lastPoint;


  @override
  void handleDrawPosUpdate(Offset pos) {
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
  void handleDrawEnd() {
    _lastPoint = null;
  }

}