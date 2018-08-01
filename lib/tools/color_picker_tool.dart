import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/drawing_tool.dart';

class ColorPickerTool extends DrawingTool {
  ColorPickerTool(context) : super(context);

  Color _currentSelectedColor;


  @override
  void handleDrawPosUpdate(Offset pos) {
    _currentSelectedColor = getPixelColor(pos);
  }

  @override
  void handleDrawEnd() {
    print(_currentSelectedColor);
    _currentSelectedColor = null;
  }

}