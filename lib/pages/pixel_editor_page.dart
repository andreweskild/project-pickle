import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/layout/responsive_scaffold.dart';
import 'package:project_pickle/widgets/pixels/canvas_gesture_container.dart';
import 'package:project_pickle/widgets/pixels/canvas_controller.dart';
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
  CanvasController _controller;

  void initController() {
    _controller = new CanvasController(
      height: widget.height,
      width: widget.width,
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_controller == null) {
      initController();
    }

    return new ResponsiveScaffold(
      name: widget.name,
      body: CanvasGestureContainer(
        canvasController: _controller,
      ),
      drawer: LeftDrawer(),
      endDrawer: RightDrawer(),
    );
  }
}