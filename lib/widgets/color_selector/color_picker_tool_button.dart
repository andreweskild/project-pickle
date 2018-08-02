import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/common/outline_icon_button.dart';

class _ColorToolModel {
  VoidCallback callback;
  ToolType currentToolType;

  _ColorToolModel({
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
    if (other is! _ColorToolModel) return false;
    _ColorToolModel model = other;
    return (model.currentToolType == currentToolType);
  }
}

class ColorPickerToolButton extends StatelessWidget {
  const ColorPickerToolButton({
    Key key,
  }) : super(key: key);

  final ToolType toolType = ToolType.color_picker;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ColorToolModel>(
      distinct: true,
      converter: (store) {
        return new _ColorToolModel(
          callback: () => store.dispatch(new SetCurrentToolTypeAction(toolType)),
          currentToolType: store.state.currentToolType,
        );
      },
      builder: (context, toolModel) {
        return OutlineIconButton(
          icon: Icons.colorize,
          onPressed: toolModel.callback,
          highlighted: toolModel.currentToolType == toolType,
        );
//        return new ListItem(
//          icon: icon,
//          label: Text(label),
//          isHighlighted: toolModel.currentToolType == toolType,
//          onTap: toolModel.callback,
//        );
      },
    );
  }
}