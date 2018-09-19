import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/tools/eraser_tool.dart';
import 'package:project_pickle/tools/fill_tool.dart';
import 'package:project_pickle/tools/gradient_tool.dart';
import 'package:project_pickle/tools/line_tool.dart';
import 'package:project_pickle/tools/pixel_tool.dart';
import 'package:project_pickle/tools/shape_tool.dart';
import 'package:project_pickle/tools/marquee_selector_tool.dart';
import 'package:project_pickle/widgets/tools/tools_list_item.dart';


class ToolsCard extends StatelessWidget {
  const ToolsCard({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ToolsListItem<PixelTool>(
              icon: Icon(Icons.brush),
              label: 'Pixel',
              onToggled: () => PixelTool(context),
            ),
            ToolsListItem<EraserTool>(
              icon: Icon(Icons.brightness_1),
              label: 'Eraser',
              onToggled: () => EraserTool(context),
            ),
            ToolsListItem<FillTool>(
              icon: Icon(Icons.brush),
              label: 'Fill',
              onToggled: () => FillTool(context),
            ),
            ToolsListItem<LineTool>(
              icon: Icon(Icons.brightness_1),
              label: 'Line',
              onToggled: () => LineTool(context),
            ),
            ToolsListItem<ShapeTool>(
              icon: Icon(Icons.crop_square),
              label: 'Shape',
              onToggled: () => ShapeTool(context),
            ),
            ToolsListItem<MarqueeSelectorTool>(
              icon: Icon(Icons.brightness_1),
              label: 'Select',
              onToggled: () => MarqueeSelectorTool(context),
            ),

          ],
        ),
      ),
    );
  }
}