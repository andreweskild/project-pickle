import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/widgets/layout/left_drawer_card.dart';
import 'package:project_pickle/widgets/tools/tools_list_item.dart';


class ToolsCard extends StatelessWidget {
  const ToolsCard({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return new LeftDrawerCard(
      title: 'Tools',
      children: <Widget>[
        new ToolsListItem(
          icon: new Icon(Icons.brush),
          label: 'Pencil Tool',
          toolType: ToolType.pencil,
        ),
        new ToolsListItem(
          icon: new Icon(Icons.brush),
          label: 'Line Tool',
          toolType: ToolType.line,
        ),
      ],
    );
  }
}