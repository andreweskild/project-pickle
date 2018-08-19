import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';

class _ToolModel {
  VoidCallback callback;
  ToolType currentToolType;
  
  _ToolModel({
    this.callback,
    this.currentToolType
  });

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + currentToolType.hashCode;
    return result;
  }
  
  @override
  bool operator ==(dynamic other) {
    if (other is! _ToolModel) return false;
    _ToolModel model = other;
    return (model.currentToolType == currentToolType);
  }
}

class ToolsListItem extends StatelessWidget {
  const ToolsListItem({
    Key key,
    this.icon,
    this.label,
    this.toolType,
  }) : super(key: key);

  final Widget icon;
  final String label;
  final ToolType toolType;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ToolModel>(
      distinct: true,
      converter: (store) {
        return new _ToolModel(
          callback: () => store.dispatch(new SetCurrentToolTypeAction(toolType)),
          currentToolType: store.state.currentToolType,
        ); 
      },
      builder: (context, toolModel) {
        final _selected = toolModel.currentToolType == toolType;
        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          child: FlatButton(
            color: _selected ? Theme.of(context).highlightColor : Colors.transparent,
            textColor: _selected ? Theme.of(context).accentTextTheme.button.color : Colors.black,
            padding: EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Stack(
              children: <Widget>[
                Align(alignment: Alignment.centerLeft, child: icon),
                Positioned(
                  left: 24.0,
                  top: 0.0,
                  bottom: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Center(child: Text(label)),
                  ),
                )
              ],
            ),
            onPressed: toolModel.callback,
          ),
        );
      },
    );
  }
}