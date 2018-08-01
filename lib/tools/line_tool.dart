import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/drawing_tool.dart';

class LineTool extends DrawingTool {
  LineTool(context) : super(context);

  Offset _startPoint;
  Offset _endPoint;

  @override
  void handleDrawPosUpdate(Offset pos) {
    if (_startPoint == null) {
      _startPoint = pos;
      drawPreviewPixel(pos);
    }
    else {
      if (_endPoint != null) {
        resetPreview();
      }
      _endPoint = pos;
      drawPreviewPixelLine(_startPoint, _endPoint);
    }
  }

  @override
  void handleDrawEnd() {
    if (_endPoint != null) {
      finalizePreview();
      resetLinePoints();
    }
  }

  void resetLinePoints() {
    _startPoint = null;
    _endPoint = null;
  }

}