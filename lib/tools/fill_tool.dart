import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/drawing_tool.dart';

class FillTool extends DrawingTool {
  FillTool(context) : super(context);

  Offset _targetPoint;


  @override
  void handleDrawPosUpdate(Offset pos) {
    _targetPoint = pos;
  }

  @override
  void handleDrawEnd() {
    fillArea(_targetPoint);
  }

}