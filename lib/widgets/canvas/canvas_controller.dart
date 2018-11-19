import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/canvas/pixel_buffer.dart';

import 'package:project_pickle/widgets/tools/select_tool_overlay.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/canvas/pixel_layer.dart';

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
//  int _visibleLayerCount;
  int _currentLayerIndex;
  Type _currentToolType;
  Color _currentColor;


  List<Widget> _populateLayerList(AppState state, BaseTool currentTool) {
    // layer pixellayers correctly so drawing of pixels is done in the correct order.
    var layers = <Widget>[];

    if (state.layers.length > 0) {
      // add current layer and all below it.
      layers.addAll(
        state.layers
          .getRange(0, state.currentLayerIndex + 1)
            .where((layer) => !layer.hidden)
              .map<PixelLayerWidget>(
                (layer) {
                  return layer.canvas;
                }
              ).toList()
      );

      // add drawing buffer above current layer.
      layers.add(
        PixelBufferWidget(
          buffer: state.drawingBuffer,
          color: state.currentColor.toColor(),
        )
      );

      // add all layers above current layer.
      layers.addAll(
        state.layers.getRange(state.currentLayerIndex + 1, state.layers.length)
          .map<PixelLayerWidget>(
            (layer) {
              return layer.canvas;
            }
          )
      );
    }
    else {
      layers = List<Widget>();
    }

    return layers;
  }


  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      rebuildOnChange: false,
      builder: (context, store) {
//        if(_visibleLayerCount == null) {
//          _visibleLayerCount = store.state.layers.where((layer) => !layer.hidden).length;
//        }
        if(_currentLayerIndex == null) {
          _currentLayerIndex = store.state.currentLayerIndex;
        }
        if(_currentToolType== null) {
          _currentToolType = store.state.currentTool.runtimeType;
        }
        if(_currentColor == null) {
          _currentColor = store.state.currentColor.toColor();
        }

        store.onChange.listen(
            (state) {
              if(state.canvasDirty) {
                state.canvasDirty = false;
                setState((){
                  _currentColor = state.currentColor.toColor();
                  _currentLayerIndex = state.currentLayerIndex;
                  _currentToolType = state.currentTool.runtimeType;
                });
              }
            }
        );

//        store.onChange.listen(
//            (state) {
//              var newLayerCount = state.layers.where((layer) => !layer.hidden).length;
//              if( newLayerCount != _visibleLayerCount ||
//                  state.currentLayerIndex != _currentLayerIndex ||
//                  state.currentTool.runtimeType != _currentToolType ||
//                  state.currentColor.toColor() != _currentColor
//              ) {
//                print('reloading canvas');
//                setState(() {
//                  _currentColor = state.currentColor.toColor();
//                  _visibleLayerCount = newLayerCount;
//                  _currentLayerIndex = state.currentLayerIndex;
//                  _currentToolType = state.currentTool.runtimeType;
//                });
//              }
//            }
//        );

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
              store.dispatch(ClearPixelBufferAction());
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
          child: Opacity(
            opacity: layers.length > 0 ? 1.0 : 0.0,
            child: SizedBox(
              width: 32.0,
              height: 32.0,
              child: Stack(
                children: <Widget>[
                  Stack(
                    fit: StackFit.expand,
                    children: layers
                  ),
                  SelectToolOverlay(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}