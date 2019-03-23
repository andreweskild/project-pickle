//import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/tangible/tangible.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_tool.dart';
import 'package:project_pickle/tools/eraser_tool.dart';
import 'package:project_pickle/tools/fill_tool.dart';
import 'package:project_pickle/tools/line_tool.dart';
import 'package:project_pickle/tools/pixel_tool.dart';
import 'package:project_pickle/tools/shape_tool.dart';
import 'package:project_pickle/tools/marquee_selector_tool.dart';
import 'package:project_pickle/widgets/tools/tool_button.dart';

typedef _ToolCreationCallback = void Function(BaseTool tool);

class _ToolsModel {
  _ToolCreationCallback callback;
  BaseTool currentTool;

  _ToolsModel({
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
    if (other is! _ToolsModel) return false;
    _ToolsModel model = other;
    return (model.currentTool.runtimeType == currentTool.runtimeType);
  }
}

List<PopupContentItem> _getToolOptions(dynamic currentTool, bool isCurrentToolType) {
  return (isCurrentToolType && currentTool.options != null)
      ? currentTool.options : 
      <PopupContentItem>[
        PopupContentItem(
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.red
              ),
            ),
          )
        )
      ];
}

class ToolsCard extends StatelessWidget {
  const ToolsCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ToolsModel>(
      converter: (store) {
        return _ToolsModel(
          callback: (toolType) => store.dispatch(SetCurrentToolAction(toolType)),
          currentTool: store.state.currentTool,
        );
      },
      builder: (context, model) {
        if(model.currentTool == null) {
          model.callback(PixelTool(context));
        }
         return DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: Theme.of(context).dividerColor
                ),
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor
                )
              ),
              color: Theme.of(context).cardColor,
            ),
            child: Padding(
             padding: const EdgeInsets.all(6.0),
             child: Column(
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.all(6.0),
                   child: ToolButton(
                     active: model.currentTool is PixelTool,
                     icon: Icon(Icons.crop_square),
                     label: 'Pixel Tool',
                     options: _getToolOptions(model.currentTool, model.currentTool is PixelTool),
                     onToggle: () => model.callback(PixelTool(context)),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(6.0),
                   child: ToolButton(
                     active: model.currentTool is EraserTool,
                     icon: Icon(Icons.crop_square),
                     label: 'Eraser Tool',
                     options: _getToolOptions(model.currentTool, model.currentTool is EraserTool),
                     onToggle: () => model.callback(EraserTool(context)),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(6.0),
                   child: ToolButton(
                     active: model.currentTool is LineTool,
                     icon: Icon(Icons.crop_square),
                     label: 'Line Tool',
                     options: _getToolOptions(model.currentTool, model.currentTool is LineTool),
                     onToggle: () => model.callback(LineTool(context)),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(6.0),
                   child: ToolButton(
                     active: model.currentTool is ShapeTool,
                     icon: Icon(Icons.crop_square),
                     label: 'Shape Tool',
                     options: _getToolOptions(model.currentTool, model.currentTool is ShapeTool),
                     onToggle: () => model.callback(ShapeTool(context)),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(6.0),
                   child: ToolButton(
                     active: model.currentTool is FillTool,
                     icon: Icon(Icons.crop_square),
                     label: 'Fill Tool',
                     options: _getToolOptions(model.currentTool, model.currentTool is FillTool),
                     onToggle: () => model.callback(FillTool(context)),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(6.0),
                   child: ToolButton(
                     active: model.currentTool is MarqueeSelectorTool,
                     icon: Icon(Icons.crop_square),
                     label: 'Selection Tool',
                     options: _getToolOptions(model.currentTool, model.currentTool is MarqueeSelectorTool),
                     onToggle: () => model.callback(MarqueeSelectorTool(context)),
                   ),
                 ),
               ],
             ),
           ),
         );
      }
    );
  }
}
