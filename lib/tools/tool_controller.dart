import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/drawing_tool_old.dart';
import 'package:project_pickle/tools/base_tool.dart';
import 'package:project_pickle/tools/color_picker_tool.dart';
import 'package:project_pickle/tools/eraser_tool.dart';
import 'package:project_pickle/tools/fill_tool.dart';
import 'package:project_pickle/tools/line_tool.dart';
import 'package:project_pickle/tools/pixel_tool.dart';
import 'package:project_pickle/tools/shape_tool.dart';
import 'package:project_pickle/tools/selector_tool.dart';
import 'package:project_pickle/tools/marquee_selector_tool.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';

class ToolController {
  ToolController(this._canvasContext) {
    _store = StoreProvider.of<AppState>(_canvasContext);
//    _inputStreamController = StreamController<Offset>();
//    _inputStream = _inputStreamController.stream;
    _currentToolType = _store.state.currentToolType;
    updateCurrentTool(_currentToolType);
    _store.onChange.listen(
      (state) => handleStateChange(state)
    );

  }

  final BuildContext _canvasContext;
  BaseTool currentTool;
  ToolType _currentToolType;
//  Stream<Offset> _inputStream;
//  StreamController<Offset> _inputStreamController;
  Offset _lastInputPos;
  Store<AppState> _store;
//
//  void handlePointerMove(details) {
//    RenderBox box = _canvasContext.findRenderObject();
//    var pos = box.globalToLocal(details.position);
//    updateInputPosition(pos);
//  }
//
//  void handlePointerDown(details) {
//    RenderBox box = _canvasContext.findRenderObject();
//    var pos = box.globalToLocal(details.position);
//    updateInputPosition(pos);
//  }
//
//  void handlePointerUp(details) {
//    if (_currentTool is DrawingTool) {
//      _currentTool as DrawingTool..handleDrawEnd();
//    }
//    else if (_currentTool is SelectorTool) {
//      _currentTool as SelectorTool..handleSelectionEnd();
//    }
//  }
//
//  void updateInputPosition(Offset pos) {
//    double snappedX = pos.dx.floorToDouble();
//    double snappedY = pos.dy.floorToDouble();
//    Offset snappedPos = Offset(snappedX, snappedY);
//    if (_lastInputPos == null) {
//      _inputStreamController.add(snappedPos);
//    }
//    else if (snappedPos != _lastInputPos) {
//      _inputStreamController.add(snappedPos);
//    }
//    _lastInputPos = snappedPos;
//  }
//
  void handleStateChange(AppState state) {
    if (_currentToolType != state.currentToolType) {
      _currentToolType = state.currentToolType;
      updateCurrentTool(_currentToolType);
    }
  }

  void updateCurrentTool(ToolType toolType) {
//    _inputStreamController = StreamController<Offset>();
//    _inputStream = _inputStreamController.stream;
    _lastInputPos = null;

    switch (toolType) {
//      case ToolType.color_picker:
//        _currentTool = ColorPickerTool(_canvasContext);
//        break;
      case ToolType.eraser:
        currentTool = EraserTool(_canvasContext);
        break;
      case ToolType.fill:
        currentTool = FillTool(_canvasContext);
        break;
      case ToolType.line:
        currentTool = LineTool(_canvasContext);
        break;
      case ToolType.pencil:
        currentTool = PixelTool(_canvasContext);
        break;
      case ToolType.shape:
        currentTool = ShapeTool(_canvasContext);
        break;
//      case ToolType.marquee_selector:
//        _currentTool = MarqueeSelectorTool(_canvasContext);
//        break;
    }

//    if (_currentTool is DrawingTool) {
//      _inputStream.listen(
//              (pos) => _currentTool as DrawingTool..handleDrawPosUpdate(pos)
//      );
//    }
//    else if (_currentTool is SelectorTool) {
//      _inputStream.listen(
//              (pos) => _currentTool as SelectorTool..handleSelectionPosUpdate(pos)
//      );
//    }

  }
 }