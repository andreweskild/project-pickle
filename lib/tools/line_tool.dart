import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/drawing_tool.dart';

class LineTool extends DrawingTool {
  LineTool() : super();

  Offset _startPoint;
  Offset _endPoint;

  @override
  void handleDrawPosUpdate(Offset pos) {
    if (_startPoint == null) {
      _startPoint = pos;
      addPixel(pos);
    }
    else {
      _endPoint = pos;
      addPixelLine(_startPoint, _endPoint);
    }
  }

  @override
  void handleDrawEnd() {
    if (onDrawFinished != null &&
        _endPoint != null) {
      onDrawFinished();
      resetLinePoints();
    }
  }

  void resetLinePoints() {
    _startPoint = null;
    _endPoint = null;
  }

}