import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/widgets/layout/drawer_card.dart';
import 'package:project_pickle/widgets/tools/tools_list_item.dart';


class ToolsCard extends StatelessWidget {
  const ToolsCard({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return DrawerCard(
      title: 'Tools',
      builder: (context, collapse) {
        return Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ToolsListItem(
                icon: new Icon(Icons.brush),
                label: 'Pencil Tool',
                toolType: ToolType.pencil,
              ),
              new ToolsListItem(
                icon: new Icon(Icons.brightness_1),
                label: 'Eraser Tool',
                toolType: ToolType.eraser,
              ),
              new ToolsListItem(
                icon: new Icon(Icons.brightness_1),
                label: 'Fill Tool',
                toolType: ToolType.fill,
              ),
              new ToolsListItem(
                icon: new Icon(Icons.brush),
                label: 'Path Tool',
                toolType: ToolType.line,
              ),
              new ToolsListItem(
                icon: new Icon(Icons.brightness_1),
                label: 'Shape Tool',
                toolType: ToolType.line,
              ),
              new ToolsListItem(
                icon: new Icon(Icons.brightness_1),
                label: 'Selection Tool',
                toolType: ToolType.line,
              ),
            ],
          ),
        );
      }
    );
  }
}