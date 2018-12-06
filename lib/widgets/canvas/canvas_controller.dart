import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/canvas/pixel_buffer.dart';

import 'package:project_pickle/widgets/tools/select_tool_overlay.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/canvas/pixel_layer.dart';

import 'package:project_pickle/tools/base_tool.dart';

class CanvasModel {
  CanvasModel({
    this.dirtyCallback,
    this.canvasDirty,
    this.drawingBuffer,
    this.activeColor,
    this.currentTool,
    this.layers
  });

  final VoidCallback dirtyCallback;
  final bool canvasDirty;
  final PixelBuffer drawingBuffer;
  final Color activeColor;
  final BaseTool currentTool;
  final PixelLayerList layers;

}

class CanvasController extends StatelessWidget {
  CanvasController({
    Key key,
    this.width,
    this.height,
    this.scale,
  }) : super(key: key);

  final int height, width;
  final double scale;


  List<Widget> _populateLayerList(CanvasModel model) {
    // layer pixellayers correctly so drawing of pixels is done in the correct order.
    var result = <Widget>[];

    if (model.layers.length > 0) {
      // add current layer and all below it.
      result.addAll(
        model.layers
          .getRange(0, model.layers.indexOfActiveLayer + 1)
            .where((layer) => !layer.hidden)
              .map<PixelLayerWidget>(
                (layer) {
                  return layer.canvas;
                }
              )
      );

      if (!model.layers.activeLayer.hidden) {
        // add drawing buffer above current layer.
        result.add(
            PixelBufferWidget(
              buffer: model.drawingBuffer,
              color: model.activeColor
            )
        );
      }


      // add all layers above current layer.
      result.addAll(
        model.layers.getRange(model.layers.indexOfActiveLayer + 1, model.layers.length)
          .where((layer) => !layer.hidden)
            .map<PixelLayerWidget>(
              (layer) {
                return layer.canvas;
              }
            )
      );
    }
    else {
      result = List<Widget>();
    }

    return result;
  }


  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CanvasModel>(
      converter: (store) {
        return CanvasModel(
          dirtyCallback: () => store.state.canvasDirty = false,
          canvasDirty: store.state.canvasDirty,
          drawingBuffer: store.state.drawingBuffer,
          activeColor: store.state.activeColor,
          currentTool: store.state.currentTool,
          layers: store.state.layers,
        );
      },
      ignoreChange: (state) => !state.canvasDirty,
      builder: (context, model) {
        // holds the current number of mouse/touch events
        int currentPointerCount = 0;
        // holds the highest number of mouse/touch events
        // that have been in contact with the screen during
        // the current gesture.

        if(model.canvasDirty) {model.dirtyCallback();}

        int maxPointerCount = 0;

        var layers = _populateLayerList(model);


        return Listener(
          onPointerMove: (details) {
            if (maxPointerCount == 1) {
              model.currentTool.handlePointerMove(details, context);
            }
          },
          onPointerDown: (details) {
            currentPointerCount += 1;
            if (maxPointerCount < currentPointerCount) {
              maxPointerCount = currentPointerCount;
            }
            if (currentPointerCount <= 1) {
              model.currentTool.handlePointerDown(details, context);
            } else {
              model.drawingBuffer.clearBuffer();
            }
          },
          onPointerUp: (details) {
            currentPointerCount -= 1;
            if (currentPointerCount == 0) {
              maxPointerCount = 0;
            }
            if (currentPointerCount == 0) {
              model.currentTool.handlePointerUp(details, context);
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