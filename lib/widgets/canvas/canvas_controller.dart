import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
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
  int _visibleLayerCount;
  int _currentLayerIndex;
  Type _currentToolType;


  List<PixelCanvasLayer> _populateLayerList(AppState state, BaseTool currentTool) {
    // layer pixellayers correctly so drawing of pixels is done in the correct order
    List<PixelCanvasLayer> layers;

    if (state.layers.length > 0) {
      layers = state.layers
          .getRange(0, state.currentLayerIndex + 1)
          .where((layer) => !layer.hidden)
          .toList();
      if (currentTool is BaseDrawingTool) {
        layers.add(currentTool.overlay);
      }
      layers.addAll(state.layers.getRange(
          state.currentLayerIndex + 1, state.layers.length));
    }
    else {
      layers = List<PixelCanvasLayer>();
    }

    return layers;
  }


  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      rebuildOnChange: false,
      builder: (context, store) {
        if(_visibleLayerCount == null) {
          _visibleLayerCount = store.state.layers.where((layer) => !layer.hidden).length;
        }
        if(_currentLayerIndex == null) {
          _currentLayerIndex = store.state.currentLayerIndex;
        }
        if(_currentToolType== null) {
          _currentToolType = store.state.currentTool.runtimeType;
        }

        store.onChange.listen(
            (state) {
              var newLayerCount = state.layers.where((layer) => !layer.hidden).length;
              if( newLayerCount != _visibleLayerCount ||
                  state.currentLayerIndex != _currentLayerIndex ||
                  state.currentTool.runtimeType != _currentToolType
              ) {
                setState(() {
                  _visibleLayerCount = newLayerCount;
                  _currentLayerIndex = state.currentLayerIndex;
                  _currentToolType = state.currentTool.runtimeType;
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

        var layers = _populateLayerList(store.state, store.state.currentTool);


        return Listener(
          onPointerMove: (details) {
            if (maxPointerCount == 1) {
              store.state.currentTool.handlePointerMove(details, context);
            }
          },
          onPointerDown: (details) {
            currentPointerCount += 1;
            if (maxPointerCount < currentPointerCount) {
              maxPointerCount = currentPointerCount;
            }
            if (currentPointerCount <= 1) {
              store.state.currentTool.handlePointerDown(details, context);
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
              store.state.currentTool.handlePointerUp(details, context);
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
//                  _toolController.selectionOverlay,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}