import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/layout/responsive_scaffold.dart';
import 'package:project_pickle/widgets/common/multi_touch_container.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas.dart';
import 'package:project_pickle/widgets/layout/left_drawer.dart';
import 'package:project_pickle/widgets/layout/right_drawer.dart';

class PixelEditorPage extends StatefulWidget {
  PixelEditorPage({
    Key key,
    this.name,
  }) : super(key: key);

  final String name;
  
  @override
  _PixelEditorPageState createState() => new _PixelEditorPageState();
}

class _PixelEditorPageState extends State<PixelEditorPage> {
  PixelCanvas _canvas = new PixelCanvas();

  @override
  Widget build(BuildContext context) {
    return new ResponsiveScaffold(
      name: widget.name,
      body: new MultiTouchContainer(
        child: new LayoutBuilder(
          builder: (context, constraints) {
            return _canvas;
          }
        )
      ),
      drawer: new LeftDrawer(),
      endDrawer: new RightDrawer(),
    );
  }
}