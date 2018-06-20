import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/list_item.dart';
import 'package:project_pickle/widgets/tools/tools_list_item.dart';

class ToolChangeNotifier extends ChangeNotifier {
  ToolChangeNotifier();
}

class ToolsDrawer extends StatelessWidget {
  const ToolsDrawer({
    Key key,
    this.onAddArtboard,
  }) : super(key: key);

  final onAddArtboard;


  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new SizedBox(
        width: 300.0,
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Card(
              child: new Padding(
                padding: const EdgeInsets.all(4.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new ListTile(
                      title: Text('Tools'),
                      trailing: new IconButton(
                        icon: new Icon(Icons.arrow_back),
                        onPressed: () {},
                      ),
                    ),
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
                ),
              ),
            ),
          ),
      ),
    );
  }
}