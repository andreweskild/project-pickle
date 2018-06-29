import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/actions/action_controller.dart';
import 'package:project_pickle/data_objects/pixel_layer.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/pixels/pixel_painter.dart';

class _CanvasModel {
  final Color color;
  final ToolType toolType;

  _CanvasModel({
    this.color,
    this.toolType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _CanvasModel &&
              color == other.color &&
              toolType == other.toolType;

  @override
  int get hashCode => color.hashCode * toolType.hashCode;
}

class PixelCanvas extends StatefulWidget {
  PixelCanvas({
    Key key,
    this.width,
    this.height
  }) : super(key: key);

  final int height, width;

  @override
  _PixelCanvasState createState() => new _PixelCanvasState();
}

class _PixelCanvasState extends State<PixelCanvas> {
  ActionController _controller;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _CanvasModel>(
      distinct: true,
      converter: (store) => new _CanvasModel(
        color: store.state.currentColor.toColor(),
        toolType: store.state.currentToolType,
      ),
      builder: (context, canvasModel) {
        if(_controller == null) {
          _controller = new ActionController(context);
        }
        _controller.setCurrentToolType(canvasModel.toolType);
        _controller.setCurrentColor(canvasModel.color);
        _controller.setCurrentLayerIndex(0);

        // holds the current number of mouse/touch events
        int currentPointerCount = 0;
        // holds the highest number of mouse/touch events
        // that have been in contact with the screen during
        // the current gesture.
        int maxPointerCount = 0;
        return new Listener(
          onPointerMove: (details) {
            if (maxPointerCount == 1) {
              _controller.handlePointerMove(details);
            }
          },
          onPointerDown: (details) {
            currentPointerCount += 1;
            if (maxPointerCount < currentPointerCount) {
              maxPointerCount = currentPointerCount;
            }
            if (currentPointerCount <= 1) {
              _controller.handlePointerDown(details);
            } else {
              _controller.clearPreview();
            }
          },
          onPointerUp: (details) {
            currentPointerCount -= 1;
            if (currentPointerCount == 0) {
              maxPointerCount = 0;
            }
            if (currentPointerCount == 0) {
              _controller.handlePointerUp(details);
            }
          },
          child: SizedBox(
            width: 32.0,
            height: 32.0,
            child: Material(
              elevation: 1.0,
              color: Colors.white,
              child: new CustomPaint(
                  willChange: true,
                  painter: new PixelPainter(_controller.finalLayers, _controller.previewLayer, _controller.changeNotifier),
                )
              ),
            ),
          );
      },
    );
  }
}