import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/base_drawing_tool.dart';

class FillTool extends BaseDrawingTool {
  FillTool(context) : super(context);

  Offset _targetPoint;


  @override
  void onPixelInputUpdate(Offset pos) {
    _targetPoint = pos;
  }

  @override
  void onPixelInputUp() {
    fillArea(_targetPoint);
  }

}