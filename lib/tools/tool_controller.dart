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
import 'package:project_pickle/widgets/tools/select_tool_overlay.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';

class ToolController {
  ToolController(this._canvasContext) {
    _store = StoreProvider.of<AppState>(_canvasContext);
    _currentToolType = _store.state.currentToolType;
    selectionOverlay = SelectToolOverlay();
    updateCurrentTool(_currentToolType);
    _store.onChange.listen(
      (state) => handleStateChange(state)
    );
  }

  final BuildContext _canvasContext;
  BaseTool currentTool;
  ToolType _currentToolType;
  SelectToolOverlay selectionOverlay;
  Store<AppState> _store;

  void handleStateChange(AppState state) {
    if (_currentToolType != state.currentToolType) {
      _currentToolType = state.currentToolType;
      updateCurrentTool(_currentToolType);
    }
  }

  void updateCurrentTool(ToolType toolType) {

    switch (toolType) {
      case ToolType.color_picker:
        currentTool = ColorPickerTool(_canvasContext);
        break;
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
      case ToolType.marquee_selector:
        currentTool = MarqueeSelectorTool(_canvasContext);
        break;
    }

  }
 }