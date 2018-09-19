import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/base_drawing_tool.dart';

class GradientTool extends BaseDrawingTool {
  GradientTool(context) : super(context);

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
      drawOverlayPixelLine(_startPoint, _endPoint);
    }
  }

  @override
  void onPixelInputUp() {
    if (_endPoint != null) {
      saveOverlayToLayer();
      resetLinePoints();
    }
  }

  void resetLinePoints() {
    _startPoint = null;
    _endPoint = null;
  }

}