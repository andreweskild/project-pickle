import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/list_item.dart';

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
    return (model.currentToolType == currentToolType && 
      model.callback == callback);
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
        return new ListItem(
          icon: icon,
          label: label,
          isHighlighted: toolModel.currentToolType == toolType,
          onTap: toolModel.callback,
        );
      },
    );
  }
}