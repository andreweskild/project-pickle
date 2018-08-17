import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/drawing_tool_old.dart';

class ShapeTool extends DrawingTool {
  ShapeTool(context) : super(context);

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
      var topLeftPoint = _startPoint;
      var topRightPoint = Offset(_endPoint.dx, _startPoint.dy);
      var bottomLeftPoint = Offset(_startPoint.dx, _endPoint.dy);
      var bottomRightPoint = _endPoint;

      drawPreviewPixelLine(topLeftPoint, topRightPoint);
      drawPreviewPixelLine(topRightPoint, bottomRightPoint);
      drawPreviewPixelLine(bottomRightPoint, bottomLeftPoint);
      drawPreviewPixelLine(bottomLeftPoint, topLeftPoint);
    }
  }

  @override
  void handleDrawEnd() {
    finalizePreview();
    resetLinePoints();
  }

  void resetLinePoints() {
    _startPoint = null;
    _endPoint = null;
  }

}