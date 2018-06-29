import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/data_objects/pixel_layer.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/tools/drawing_tool.dart';
import 'package:project_pickle/tools/tool.dart';
import 'package:project_pickle/tools/line_tool.dart';
import 'package:project_pickle/tools/pencil_tool.dart';

class LayerChangeNotifier extends ChangeNotifier {
  LayerChangeNotifier();
}

class ActionController {
  final BuildContext _canvasContext;
  Stream<Offset> _inputStream;
  StreamController<Offset> _inputStreamController;
  Offset _lastInputPos;

  ActionController(this._canvasContext) {
    _inputStreamController = new StreamController<Offset>();
    _inputStream = _inputStreamController.stream;
  }

  final previewLayer = new HashMap<Offset, Color>();
  final finalLayers = <PixelLayer>[new PixelLayer('Layer 1')];
  final changeNotifier = new LayerChangeNotifier();

  PixelLayer get currentLayer => finalLayers[_currentLayerIndex];
  int _currentLayerIndex;

  Color _currentColor;
  Tool _currentTool;

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
      if(_currentTool is LineTool) {
        previewLayer.clear();
      }
      _inputStreamController.add(snappedPos);
    }
    else if (snappedPos != _lastInputPos) {
      if(_currentTool is LineTool) {
        previewLayer.clear();
      }
      _inputStreamController.add(snappedPos);
    }
    _lastInputPos = snappedPos;
  }

  void setCurrentColor(Color color) {
    if (_currentColor != color) {
      _currentColor = color;
    }
  }

  void setCurrentToolType(ToolType toolType) {
    _inputStreamController = new StreamController<Offset>();
    _inputStream = _inputStreamController.stream;
    switch (toolType) {
      case ToolType.line: 
        _currentTool = new LineTool();
        _currentTool as DrawingTool
          ..drawUpdate.listen((pos) => addPreviewPixel(pos.dx, pos.dy))
          ..onDrawFinished = finalizePreview;
        _inputStream.listen(
          (pos) => _currentTool as DrawingTool..handleDrawPosUpdate(pos)
        );
        break;
      case ToolType.pencil: 
        _currentTool = new PencilTool();
        _currentTool as DrawingTool
          ..drawUpdate.listen((pos) => addPreviewPixel(pos.dx, pos.dy))
          ..onDrawFinished = finalizePreview;
        _inputStream.listen(
          (pos) => _currentTool as DrawingTool..handleDrawPosUpdate(pos)
        );
        break;
    }

  }

  void setCurrentLayerIndex(int newLayerIndex) {
    if (_currentLayerIndex != newLayerIndex) {
      _currentLayerIndex = newLayerIndex;
    }
  }

  void addPreviewPixel(double x, double y) {
    previewLayer[new Offset(x,y)] = _currentColor;
    changeNotifier.notifyListeners();
  }

  void clearPreview() {
    previewLayer.clear();
  }

  void finalizePreview() {
    previewLayer.forEach((pos, color) {
        if (!currentLayer.pixels.containsKey(pos)) {
          currentLayer.pixels[pos] = color;
        }
        else if(currentLayer.pixels[pos] != color) {
          currentLayer.pixels[pos] = color;
        }
      }
    );
    clearPreview();
    changeNotifier.notifyListeners();
  }
}