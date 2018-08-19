import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_drawing_tool.dart';

class PixelTool extends BaseDrawingTool {
  PixelTool(context) : super(context);

  Offset _lastPoint;


  @override
  void onPixelInputUpdate(Offset pos) {
    if ( _lastPoint != null &&
        ((_lastPoint.dx - pos.dx).abs() > 1 ||
            (_lastPoint.dy - pos.dy).abs() > 1)) {
      drawOverlayPixelLine(_lastPoint, pos);
    }
    else {
      drawOverlayPixel(pos);
    }
    _lastPoint = pos;
  }

  @override
  void onPixelInputUp() {
    saveOverlayToLayer();
    _lastPoint = null;
  }

}