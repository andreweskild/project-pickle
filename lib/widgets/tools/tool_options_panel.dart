import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';

/// Presents options and settings to customize the currently selected tool
///
///
class ToolOptionsPanel extends StatelessWidget {
  ToolOptionsPanel({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Widget>>(
      converter: (store) {
        if(store.state.currentTool != null) {
          return store.state.currentTool.options;
        }
        else {
          return null;
        }
      },
      builder: (context, options) {
        if(options != null) {
          return SizedBox(
            height: 56.0,
            child: Material(
              elevation: 2.0,
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                    color: Theme.of(context).dividerColor,
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: options ?? <Widget>[],
                ),
              ),
            ),
          );
        }
        else {
          return SizedBox(height: 0.0, width: 0.0);
        }
      }
    );
  }
}