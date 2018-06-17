import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/list_item.dart';

class ToolState {
  ToolState({
    this.callback,
    this.currentToolType
  });

  VoidCallback callback;
  ToolType currentToolType;
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
    return new StoreConnector<AppState, ToolState>(
      converter: (store) {
        return new ToolState(
          callback: () => store.dispatch(new SetCurrentToolTypeAction(toolType)),
          currentToolType: store.state.currentToolType,
          ); 
      },
      builder: (context, state) {
        return new ListItem(
          icon: icon,
          label: label,
          isHighlighted: state.currentToolType == toolType,
          onTap: state.callback,
        );
      },
    );
  }
}