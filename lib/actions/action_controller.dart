import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/pixel.dart';
import 'package:project_pickle/data_objects/pixel_layer.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/drawing_tool.dart';
import 'package:project_pickle/tools/tool.dart';
import 'package:project_pickle/tools/line_tool.dart';
import 'package:project_pickle/tools/mixins/pointer_input.dart';
import 'package:project_pickle/tools/pencil_tool.dart';
import 'package:project_pickle/widgets/pixels/pixel_painter.dart';

class LayerChangeNotifier extends ChangeNotifier {
  LayerChangeNotifier();
}


class ActionController {
  final BuildContext _canvasContext;
  Stream<Offset> _inputStream;
  StreamController<Offset> _inputStreamController;

  ActionController(this._canvasContext) {
    _inputStreamController = new StreamController<Offset>();
    _inputStream = _inputStreamController.stream;
  }

  final previewLayer = new HashMap<Offset, Color>();
  final finalLayers = <PixelLayer>[new PixelLayer('Layer 1')];
  final changeNotifier = new LayerChangeNotifier();

  PixelLayer get currentLayer => finalLayers[_currentLayerIndex];
  
  int _currentLayerIndex;
  Tool _currentTool;

  void handlePanUpdate(details) {
    RenderBox box = _canvasContext.findRenderObject();
    var pos = box.globalToLocal(details.globalPosition);
    if(_currentTool is LineTool) {
      previewLayer.clear();
    }
    updateInputPosition(pos);
  }
  
  void handlePanDown(details) {
    RenderBox box = _canvasContext.findRenderObject();
    var pos = box.globalToLocal(details.globalPosition);
    updateInputPosition(pos);
  }

  void handlePanEnd(details) => _currentTool as DrawingTool..handleDrawEnd();
  void handleTapUp(details) => _currentTool as DrawingTool..handleDrawEnd();

  void updateInputPosition(Offset pos) {
    double snappedX = pos.dx.floorToDouble();
    double snappedY = pos.dy.floorToDouble();
    _inputStreamController.add(new Offset(snappedX, snappedY));
  }

  void setCurrentToolType(ToolType toolType) {
    _inputStreamController = new StreamController<Offset>();
    _inputStream = _inputStreamController.stream;
    switch (toolType) {
      case ToolType.line: 
        _currentTool = new LineTool();
        _currentTool as DrawingTool
          ..drawUpdate.listen((pos) => addPreviewPixel(pos.dx, pos.dy, Colors.purple))
          ..onDrawFinished = finalizePreview;
        _inputStream.listen(
          (pos) => _currentTool as DrawingTool..handleDrawPosUpdate(pos)
        );
        break;
      case ToolType.pencil: 
        _currentTool = new PencilTool();
        _currentTool as DrawingTool
          ..drawUpdate.listen((pos) => addPreviewPixel(pos.dx, pos.dy, Colors.purple))
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

  void addPreviewPixel(double x, double y, Color color) {
    previewLayer[new Offset(x,y)] = color;
    changeNotifier.notifyListeners();
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
    previewLayer.clear();
    print('pixels: ${currentLayer.pixels.length}');
    print('preview: ${previewLayer.length}');
    changeNotifier.notifyListeners();
  }
}