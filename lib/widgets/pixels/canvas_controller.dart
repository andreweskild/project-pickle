import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/tools/tool_controller.dart';
import 'package:project_pickle/state/app_state.dart';

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


  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      rebuildOnChange: false,
      builder: (context, store) {
        if(_toolController == null) {
          _toolController = ToolController(context);
        }
        
        // holds the current number of mouse/touch events
        int currentPointerCount = 0;
        // holds the highest number of mouse/touch events
        // that have been in contact with the screen during
        // the current gesture.

        int maxPointerCount = 0;
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
                children: <Widget>[
                  Stack(
                    children: store.state.layers,
                  ),
                  store.state.previewLayer,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}