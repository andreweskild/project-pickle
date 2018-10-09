import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_tool.dart';
import 'package:project_pickle/widgets/common/two_stage_popup_button.dart';

typedef _ToolCreationCallback = void Function(BaseTool tool);
typedef _ToolToggleCallback = BaseTool Function();

class _ToolModel {
  _ToolCreationCallback callback;
  BaseTool currentTool;

  _ToolModel({
    this.callback,
    this.currentTool,
  });

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + currentTool.hashCode;
    return result;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! _ToolModel) return false;
    _ToolModel model = other;
    return (model.currentTool.runtimeType == currentTool.runtimeType);
  }
}

class ToolsListItem<T> extends StatelessWidget {
  const ToolsListItem({Key key, this.icon, this.label, this.onToggled})
      : super(key: key);

  final Widget icon;
  final String label;
  final _ToolToggleCallback onToggled;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ToolModel>(
      distinct: true,
      converter: (store) {
        return new _ToolModel(
          callback: (tool) => store.dispatch(new SetCurrentToolAction(tool)),
          currentTool: store.state.currentTool,
        );
      },
      builder: (context, toolModel) {
        final _selected = toolModel.currentTool is T;
        return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            child: TwoStagePopupButton(
              header: AnimatedPadding(
                curve: Curves.ease,
                duration: Duration(milliseconds: 150),
                padding: const EdgeInsets.all(0.0),
                child: Stack(
                  children: <Widget>[
                    Align(alignment: Alignment.centerLeft, child: icon),
                    Positioned(
                      left: 24.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Center(
                          child: Text(
                              label,
                            style: TextStyle(
                              fontWeight: (_selected) ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              popupContent: (_selected && toolModel.currentTool.options != null)
                  ? Column(children: toolModel.currentTool.options)
                  : Placeholder(),
              onToggled: () => toolModel.callback(onToggled()),
              active: _selected,
            )
//          child: FlatButton(
//            color: _selected ? Theme.of(context).highlightColor : Theme.of(context).buttonColor,
//            textColor: _selected ? Theme.of(context).accentTextTheme.button.color : Colors.black,
//            padding: EdgeInsets.all(8.0),
//            shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(8.0),
//            ),
//            child: AnimatedPadding(
//              curve: Curves.ease,
//              duration: Duration(milliseconds: 150),
//              padding: (toolModel.sizeMode == DrawerSizeMode.Mini) ?
//                const EdgeInsets.all(0.0) :
//                const EdgeInsets.only(left: 8.0, right: 8.0),
//              child: Stack(
//                children: <Widget>[
//                  Align(alignment: Alignment.centerLeft, child: icon),
//                  Positioned(
//                    left: 24.0,
//                    top: 0.0,
//                    bottom: 0.0,
//                    child: Padding(
//                      padding: const EdgeInsets.only(left: 12.0),
//                      child: Center(child: Text(label)),
//                    ),
//                  )
//                ],
//              ),
//            ),
//            onPressed: () => toolModel.callback(onToggled()),
//          ),
            );
      },
    );
  }
}
