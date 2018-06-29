import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/layout/responsive_scaffold.dart';
import 'package:project_pickle/widgets/pixels/canvas_gesture_container.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas.dart';
import 'package:project_pickle/widgets/layout/left_drawer.dart';
import 'package:project_pickle/widgets/layout/right_drawer.dart';

class PixelEditorPage extends StatefulWidget {
  PixelEditorPage({
    Key key,
    this.name,
  }) : super(key: key);

  final int height = 32, width = 32;

  final String name;
  
  @override
  _PixelEditorPageState createState() => new _PixelEditorPageState();
}

class _PixelEditorPageState extends State<PixelEditorPage> {
  PixelCanvas _canvas;

  void initCanvas() {
    _canvas = new PixelCanvas(
      height: widget.height,
      width: widget.width,
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_canvas == null) {
      initCanvas();
    }

    return new ResponsiveScaffold(
      name: widget.name,
      body: new CanvasGestureContainer(
        canvas: _canvas,
      ),
      drawer: new LeftDrawer(),
      endDrawer: new RightDrawer(),
    );
  }
}