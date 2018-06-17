import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../state/app_state.dart';
import '../elements/list_item.dart';
import '../tools/tool_types.dart';


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
    return new Drawer(
      elevation: 1.0,
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new StoreConnector<AppState, String>(
            converter: (store) => store.state.currentToolType.toString(),
            builder: (context, count) {
              return new Text(
                count,
                style: Theme.of(context).textTheme.display1,
              );
            },
          ),
          new StoreConnector<AppState, VoidCallback>(
            converter: (store) {
              // Return a `VoidCallback`, which is a fancy name for a function
              // with no parameters. It only dispatches an Increment action.
              return () => store.dispatch(new SetCurrentToolTypeAction(ToolType.pencil));
            },
            builder: (context, callback) {
              return new ListItem(
                icon: new Icon(Icons.brush),
                label: 'Pencil Tool',
                onTap: callback,
              );
            },
          ),
          new StoreConnector<AppState, VoidCallback>(
            converter: (store) {
              // Return a `VoidCallback`, which is a fancy name for a function
              // with no parameters. It only dispatches an Increment action.
              return () => store.dispatch(new SetCurrentToolTypeAction(ToolType.line));
            },
            builder: (context, callback) {
              return new ListItem(
                icon: new Icon(Icons.brush),
                label: 'Line Tool',
                onTap: callback,
              );
            },
          ),
          new ListItem(
            icon: new Icon(Icons.brush),
            label: 'Eraser Tool',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}