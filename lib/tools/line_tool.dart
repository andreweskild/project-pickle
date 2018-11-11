import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/base_drawing_tool.dart';

class LineTool extends BaseDrawingTool {
  LineTool(context) : super(context);

  Offset _startPoint;
  Offset _endPoint;

  @override
  void onPixelInputUpdate(Offset pos) {
    if (_startPoint == null) {
      _startPoint = pos;
      drawPixelToBuffer(pos);
    }
    else {
      if (_endPoint != null) {
        clearBuffer();
      }
      _endPoint = pos;
      drawPixelLineToBuffer(_startPoint, _endPoint);
    }
  }

  @override
  void onPixelInputUp() {
    if (_endPoint != null) {
      finalizeBuffer();
      resetLinePoints();
    }
  }

  void resetLinePoints() {
    _startPoint = null;
    _endPoint = null;
  }

}