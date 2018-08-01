import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/tools/tool_controller.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas_layer.dart';

class CanvasModel {
  CanvasModel(
    this.currentToolType,
  );

  ToolType currentToolType;
  VoidCallback clearPreviewCallback;
}

class CanvasController extends StatefulWidget {
  CanvasController({
    Key key,
    this.width,
    this.height
  }) : super(key: key);

  final int height, width;

  @override
  _CanvasControllerState createState() => new _CanvasControllerState();
}

class _CanvasControllerState extends State<CanvasController> {
  ToolController _toolController;
  int _layerCount;
  int _currentLayerIndex;


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

        store.onChange.listen(
            (state) {
              if(state.layers.length != _layerCount ||
                state.currentLayerIndex != _currentLayerIndex) {
                setState(() {
                  _layerCount = state.layers.length;
                  _currentLayerIndex = state.currentLayerIndex;
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

        // layer pixellayers correctly so drawing of pixels is done in the correct order
        List<PixelCanvasLayer> layers;
        layers = store.state.layers.getRange(0, store.state.currentLayerIndex + 1).toList();
        layers.add(store.state.previewLayer);
        layers.addAll(store.state.layers.getRange(store.state.currentLayerIndex + 1, store.state.layers.length));


        return Listener(
          onPointerMove: (details) {
            if (maxPointerCount == 1) {
              _toolController.handlePointerMove(details);
            }
          },
          onPointerDown: (details) {
            currentPointerCount += 1;
            if (maxPointerCount < currentPointerCount) {
              maxPointerCount = currentPointerCount;
            }
            if (currentPointerCount <= 1) {
              _toolController.handlePointerDown(details);
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
              _toolController.handlePointerUp(details);
            }
          },
          child: Material(
            color: Colors.white,
            elevation: 1.0,
            child: SizedBox(
              width: 32.0,
              height: 32.0,
              child: Stack(
                children: layers
              ),
            ),
          ),
        );
      },
    );
  }
}