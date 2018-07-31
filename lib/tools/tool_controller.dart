import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/drawing_tool.dart';
import 'package:project_pickle/tools/tool.dart';
import 'package:project_pickle/tools/eraser_tool.dart';
import 'package:project_pickle/tools/fill_tool.dart';
import 'package:project_pickle/tools/line_tool.dart';
import 'package:project_pickle/tools/pencil_tool.dart';

class LayerChangeNotifier extends ChangeNotifier {
  LayerChangeNotifier();
}

class ToolController {
  final BuildContext _canvasContext;
  Store<AppState> _store;
  Stream<Offset> _inputStream;
  StreamController<Offset> _inputStreamController;
  Offset _lastInputPos;
  ToolType _currentToolType;
  Tool _currentTool;

  ToolController(this._canvasContext) {
    _store = StoreProvider.of<AppState>(_canvasContext);
    _inputStreamController = new StreamController<Offset>();
    _inputStream = _inputStreamController.stream;
    _currentToolType = _store.state.currentToolType;
    updateCurrentTool();
    _store.onChange.listen(
      (state) => handleStateChange(state)
    );
  }


  void handlePointerMove(details) {
    RenderBox box = _canvasContext.findRenderObject();
    var pos = box.globalToLocal(details.position);
    updateInputPosition(pos);
  }
  
  void handlePointerDown(details) {
    RenderBox box = _canvasContext.findRenderObject();
    var pos = box.globalToLocal(details.position);
    updateInputPosition(pos);
  }

  void handlePointerUp(details) => _currentTool as DrawingTool..handleDrawEnd();

  void updateInputPosition(Offset pos) {
    double snappedX = pos.dx.floorToDouble();
    double snappedY = pos.dy.floorToDouble();
    Offset snappedPos = new Offset(snappedX, snappedY);
    if (_lastInputPos == null) {
      _inputStreamController.add(snappedPos);
    }
    else if (snappedPos != _lastInputPos) {
      _inputStreamController.add(snappedPos);
    }
    _lastInputPos = snappedPos;
  }

  void handleStateChange(AppState state) {
    if (_currentToolType != state.currentToolType) {
      _currentToolType = state.currentToolType;
      updateCurrentTool();
    }
  }

  void updateCurrentTool() {
    _inputStreamController = new StreamController<Offset>();
    _inputStream = _inputStreamController.stream;
    switch (_currentToolType) {
      case ToolType.colorPicker:
        _currentTool = new PencilTool(_canvasContext);
        _inputStream.listen(
                (pos) => _currentTool as DrawingTool..handleDrawPosUpdate(pos)
        );
        break;
      case ToolType.eraser:
        _currentTool = new EraserTool(_canvasContext);
        _inputStream.listen(
          (pos) => _currentTool as DrawingTool..handleDrawPosUpdate(pos)
        );
        break;
      case ToolType.fill:
        _currentTool = new FillTool(_canvasContext);
        _inputStream.listen(
          (pos) => _currentTool as DrawingTool..handleDrawPosUpdate(pos)
        );
        break;
      case ToolType.line: 
        _currentTool = new LineTool(_canvasContext);
        _inputStream.listen(
          (pos) => _currentTool as DrawingTool..handleDrawPosUpdate(pos)
        );
        break;
      case ToolType.pencil: 
        _currentTool = new PencilTool(_canvasContext);
        _inputStream.listen(
          (pos) => _currentTool as DrawingTool..handleDrawPosUpdate(pos)
        );
        break;
    }

  }
 }