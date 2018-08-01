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
      builder: (context, collapsed) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: ToolsListItem(
                        icon: Icon(Icons.brush),
                        label: 'Pencil',
                        toolType: ToolType.pencil,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: ToolsListItem(
                        icon: Icon(Icons.brightness_1),
                        label: 'Eraser',
                        toolType: ToolType.eraser,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: ToolsListItem(
                        icon: Icon(Icons.brush),
                        label: 'Fill',
                        toolType: ToolType.fill,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: ToolsListItem(
                        icon: Icon(Icons.brightness_1),
                        label: 'Path',
                        toolType: ToolType.line,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: ToolsListItem(
                        icon: Icon(Icons.brush),
                        label: 'Shape',
                        toolType: ToolType.shape,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: ToolsListItem(
                        icon: Icon(Icons.brightness_1),
                        label: 'Select',
                        toolType: ToolType.line,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}