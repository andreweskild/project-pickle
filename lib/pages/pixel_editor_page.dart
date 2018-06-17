import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../layout/tools_drawer.dart';
import '../layout/properties_drawer.dart';
import '../layout/responsive_scaffold.dart';

import '../data_objects/artboard.dart';
import '../data_objects/pixel_controller.dart';
import '../elements/multi_touch_container.dart';
import '../elements/pixel_canvas.dart';

class PixelEditorPage extends StatefulWidget {
  PixelEditorPage({
    Key key,
    this.name,
    this.artboard,
  }) : super(key: key);

  final String name;

  final Artboard artboard;

  final _pixelController = new PixelController();
  
  @override
  _PixelEditorPageState createState() => new _PixelEditorPageState();
}

class _PixelEditorPageState extends State<PixelEditorPage> {

  @override
  Widget build(BuildContext context) {
    return new ResponsiveScaffold(
      name: widget.name,
      body: new MultiTouchContainer(
        child: new LayoutBuilder(
          builder: (context, constraints) {
            return widget._pixelController;
          }
        )
      ),
      drawer: new ToolsDrawer(),
      endDrawer: new ObjectPropertiesDrawer(),
    );
  }
}