import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/actions/action_controller.dart';
import 'package:project_pickle/data_objects/pixel_layer.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/pixels/pixel_painter.dart';


class PixelCanvas extends StatefulWidget {
  PixelCanvas({
    Key key,
  }) : super(key: key);

  @override
  _PixelCanvasState createState() => new _PixelCanvasState();
}

class _PixelCanvasState extends State<PixelCanvas> {
  ActionController _controller;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, ToolType>(
            converter: (store) => store.state.currentToolType,
            builder: (context, toolType) {
              if(_controller == null) {
                _controller = new ActionController(context);
              }
              _controller.setCurrentToolType(toolType);
              _controller.setCurrentLayerIndex(0);

              return new GestureDetector(
                onPanUpdate: (details) {
                  _controller.handlePanUpdate(details);
                },
                onPanDown: (details) {
                  _controller.handlePanDown(details);
                },
                onPanEnd: (details) {
                  _controller.handlePanEnd(details);
                },
                onTapUp: (details) {
                  _controller.handleTapUp(details);
                },
                child: SizedBox(
                  width: 32.0,
                  height: 32.0,
                  child: DecoratedBox(
                    decoration: new BoxDecoration(
                      color: Colors.white
                    ),
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