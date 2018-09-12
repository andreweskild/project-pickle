import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/value_slider.dart';

/// Presents options and settings to customize the currently selected tool
///
///
class ToolOptionsPanel extends StatefulWidget {
  ToolOptionsPanel({
    Key key,
  }) : super(key: key);

  ToolOptionsPanelState createState() => ToolOptionsPanelState();
}

class ToolOptionsPanelState extends State<ToolOptionsPanel> {
  double value1 = 0.0;
  double value2 = 0.3;

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
        return SizedBox(
          height: 64.0,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, left: 12.0, bottom: 4.0),
                        child: Text('Size'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ValueSlider(
                          value: value1,
                          onChanged: (value){
                            setState((){
                              value1 = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, left: 12.0, bottom: 4.0),
                        child: Text('Opacity'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ValueSlider(
                          value: value2,
                          onChanged: (value){
                            setState((){
                              value2 = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            ),
          ),
        );
      }
    );
  }
}