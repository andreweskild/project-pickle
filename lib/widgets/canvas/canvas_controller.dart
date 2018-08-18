import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/tools/tool_controller.dart';
import 'package:project_pickle/widgets/tools/select_tool_overlay.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';

import 'package:project_pickle/tools/base_drawing_tool.dart';
import 'package:project_pickle/tools/base_tool.dart';

class CanvasController extends StatefulWidget {
  CanvasController({
    Key key,
    this.width,
    this.height,
    this.scale,
  }) : super(key: key);

  final int height, width;
  final double scale;

  @override
  _CanvasControllerState createState() => new _CanvasControllerState();
}

class _CanvasControllerState extends State<CanvasController> {
  ToolController _toolController;
  int _layerCount;
  int _currentLayerIndex;
  ToolType _currentToolType;


  List<PixelCanvasLayer> _populateLayerList(AppState state, BaseTool currentTool) {
    // layer pixellayers correctly so drawing of pixels is done in the correct order
    List<PixelCanvasLayer> layers = state.layers.getRange(0, state.currentLayerIndex + 1).toList();
    if(currentTool is BaseDrawingTool) {
      layers.add(currentTool.overlay);
    }
    layers.addAll(state.layers.getRange(state.currentLayerIndex + 1, state.layers.length));

    return layers;
  }


  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      rebuildOnChange: false,
      builder: (context, store) {
        if(_toolController == null) {
          _toolController = ToolController(context);
        }
        if(_layerCount == null) {
          _layerCount = store.state.layers.length;
        }
        if(_currentLayerIndex == null) {
          _currentLayerIndex = store.state.currentLayerIndex;
        }
        if(_currentToolType == null) {
          _currentToolType = store.state.currentToolType;
        }

        store.onChange.listen(
            (state) {
              if(state.layers.length != _layerCount ||
                  state.currentLayerIndex != _currentLayerIndex ||
                  state.currentToolType != _currentToolType) {
                setState(() {
                  _layerCount = state.layers.length;
                  _currentLayerIndex = state.currentLayerIndex;
                  _currentToolType = state.currentToolType;
                });
              }
            }
        );

        // holds the current number of mouse/touch events
        int currentPointerCount = 0;
        // holds the highest number of mouse/touch events
        // that have been in contact with the screen during
        // the current gesture.

        int maxPointerCount = 0;

        var layers = _populateLayerList(store.state, _toolController.currentTool);


        return Listener(
          onPointerMove: (details) {
            if (maxPointerCount == 1) {
              _toolController.currentTool.handlePointerMove(details);
//              _currentTool.handlePointerMove(details);
            }
          },
          onPointerDown: (details) {
            currentPointerCount += 1;
            if (maxPointerCount < currentPointerCount) {
              maxPointerCount = currentPointerCount;
            }
            if (currentPointerCount <= 1) {
              _toolController.currentTool.handlePointerDown(details);
//              _currentTool.handlePointerDown(details);
            } else {
              store.dispatch(ClearPreviewAction());
            }
          },
          onPointerUp: (details) {
            currentPointerCount -= 1;
            if (currentPointerCount == 0) {
              maxPointerCount = 0;
            }
            if (currentPointerCount == 0) {
              _toolController.currentTool.handlePointerUp(details);
//              _currentTool.handlePointerUp(details);
            }
          },
          child: Material(
            color: Colors.white,
            elevation: 1.0,
            child: SizedBox(
              width: 32.0,
              height: 32.0,
              child: Stack(
                children: <Widget>[
                  Stack(
                    children: layers
                  ),
                  _toolController.selectionOverlay,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}