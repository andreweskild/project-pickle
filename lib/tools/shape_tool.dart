import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/base_drawing_tool.dart';

class ShapeTool extends BaseDrawingTool {
  ShapeTool(context) : super(context);

  Offset _startPoint;
  Offset _endPoint;

  @override
  void onPixelInputUpdate(Offset pos) {
    if (_startPoint == null) {
      _startPoint = pos;
      drawOverlayPixel(pos);
    }
    else {
      if (_endPoint != null) {
        resetOverlay();
      }
      _endPoint = pos;
      var topLeftPoint = _startPoint;
      var topRightPoint = Offset(_endPoint.dx, _startPoint.dy);
      var bottomLeftPoint = Offset(_startPoint.dx, _endPoint.dy);
      var bottomRightPoint = _endPoint;

      drawOverlayPixelLine(topLeftPoint, topRightPoint);
      drawOverlayPixelLine(topRightPoint, bottomRightPoint);
      drawOverlayPixelLine(bottomRightPoint, bottomLeftPoint);
      drawOverlayPixelLine(bottomLeftPoint, topLeftPoint);
    }
  }

  @override
  void onPixelInputUp() {
    saveOverlayToLayer();
    resetLinePoints();
  }

  void resetLinePoints() {
    _startPoint = null;
    _endPoint = null;
  }

}