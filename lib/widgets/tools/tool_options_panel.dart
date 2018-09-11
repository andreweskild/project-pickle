import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/value_slider.dart';

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
              elevation: 4.0,
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [
                    ValueSlider(
                      value: 0.5,
                      onChanged: (value){},
                    )
                  ]
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