import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/widgets/tools/tools_list_item.dart';


class ToolsCard extends StatelessWidget {
  const ToolsCard({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ToolsListItem(
            icon: Icon(Icons.brush),
            label: 'Pencil',
            toolType: ToolType.pencil,
          ),
          ToolsListItem(
            icon: Icon(Icons.brightness_1),
            label: 'Eraser',
            toolType: ToolType.eraser,
          ),
          ToolsListItem(
            icon: Icon(Icons.brush),
            label: 'Fill',
            toolType: ToolType.fill,
          ),
          ToolsListItem(
            icon: Icon(Icons.gradient),
            label: 'Gradient',
            toolType: ToolType.gradient,
          ),
          ToolsListItem(
            icon: Icon(Icons.brightness_1),
            label: 'Path',
            toolType: ToolType.line,
          ),
          ToolsListItem(
            icon: Icon(Icons.brush),
            label: 'Shape',
            toolType: ToolType.shape,
          ),
          ToolsListItem(
            icon: Icon(Icons.brightness_1),
            label: 'Select',
            toolType: ToolType.marquee_selector,
          ),

        ],
      ),
    );
  }
}