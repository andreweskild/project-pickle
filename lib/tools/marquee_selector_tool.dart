import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/tools/selector_tool.dart';

/// Tool for selecting pixels in a rectangle selection.
class MarqueeSelectorTool extends SelectorTool {
  MarqueeSelectorTool(context) : super(context);

  Offset _startPoint;
  Offset _endPoint;

  @override
  void onPixelInputUpdate(Offset pos) {
    if(_startPoint == null) {
      _startPoint = pos;
    }
    else {
      if (pos.dx < _startPoint.dx) {
        if (pos.dy < _startPoint.dy) {
          _endPoint = pos + Offset(0.0, 0.0);
        }
        else {
          _endPoint = pos + Offset(0.0, 1.0);
        }
      }
      else {
        if (pos.dy < _startPoint.dy) {
          _endPoint = pos + Offset(1.0, 0.0);
        }
        else {
          _endPoint = pos + Offset(1.0, 1.0);
        }
      }
      var selectionRect = Path()..addRect(
        Rect.fromPoints(_startPoint, _endPoint)
      );
      setSelectionPath(selectionRect);
    }
  }

  @override
  void onPixelInputUp() {
    if (_startPoint == null ||
        _endPoint == null) {
      deselectPath();
    }
    _startPoint = null;
    _endPoint = null;
  }

}