import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/drawing_tool.dart';

class PencilTool extends DrawingTool {
  PencilTool() : super();

  Offset _lastPoint;


  @override
  void handleDrawPosUpdate(Offset pos) {
    if ( _lastPoint != null &&
        ((_lastPoint.dx - pos.dx).abs() > 1 || 
        (_lastPoint.dy - pos.dy).abs() > 1)) {
        addPixelLine(_lastPoint, pos);
    }
    else {
      addPixel(pos);
    }
    _lastPoint = pos;
  }

  @override
  void handleDrawEnd() {
    if (onDrawFinished != null) {
      onDrawFinished();
      _lastPoint = null;
    }
  }

}