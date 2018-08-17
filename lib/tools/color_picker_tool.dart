import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/drawing_tool_old.dart';

class ColorPickerTool extends DrawingTool {
  ColorPickerTool(context) : super(context);

  Color _currentSelectedColor;


  @override
  void handleDrawPosUpdate(Offset pos) {
    _currentSelectedColor = getPixelColor(pos);
  }

  @override
  void handleDrawEnd() {
    updateCurrentColor(_currentSelectedColor);
    _currentSelectedColor = null;
  }

}