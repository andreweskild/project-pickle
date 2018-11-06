import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_tool.dart';
import 'package:project_pickle/tools/eraser_tool.dart';
import 'package:project_pickle/tools/fill_tool.dart';
import 'package:project_pickle/tools/gradient_tool.dart';
import 'package:project_pickle/tools/line_tool.dart';
import 'package:project_pickle/tools/pixel_tool.dart';
import 'package:project_pickle/tools/shape_tool.dart';
import 'package:project_pickle/tools/marquee_selector_tool.dart';
import 'package:project_pickle/widgets/common/expandable_button.dart';
import 'package:project_pickle/widgets/tools/tool_button.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
import 'package:project_pickle/widgets/tools/tool_list_button.dart';

typedef _ToolCreationCallback = void Function(BaseTool tool);
typedef _ToolToggleCallback = BaseTool Function();

class _ToolsModel {
  _ToolCreationCallback callback;
  BaseTool currentTool;
  DrawerSizeMode sizeMode;

  _ToolsModel({
    this.callback,
    this.currentTool,
    this.sizeMode,
  });

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + currentTool.hashCode;
    result = 37 * result + sizeMode.hashCode;
    return result;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! _ToolsModel) return false;
    _ToolsModel model = other;
    return (model.currentTool.runtimeType == currentTool.runtimeType &&
      model.sizeMode == sizeMode);
  }
}

BaseTool _createToolFromIndex(BuildContext context, int index) {
  switch(index) {
    case 0: return PixelTool(context);
    case 1: return EraserTool(context);
    case 2: return LineTool(context);
    case 3: return ShapeTool(context);
    case 4: return FillTool(context);
    case 5: return MarqueeSelectorTool(context);
  }
}

Widget _getToolOptions(dynamic currentTool, bool isCurrentToolType) {
  return (isCurrentToolType && currentTool.options != null)
      ? currentTool.options : SizedBox();
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
          sizeMode: store.state.leftDrawerSizeMode,
        );
      },
      builder: (context, model) {
         return Padding(
           padding: const EdgeInsets.all(6.0),
           child: Column(
             children: <Widget>[
               Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: ToolButton(
                   active: model.currentTool is PixelTool,
                   icon: Icon(Icons.crop_square),
                   label: Text('Pixel Tool'),
                   options: _getToolOptions(model.currentTool, model.currentTool is PixelTool),
                   onToggle: () => model.callback(PixelTool(context)),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: ToolButton(
                   active: model.currentTool is EraserTool,
                   icon: Icon(Icons.crop_square),
                   label: Text('Eraser Tool'),
                   options: _getToolOptions(model.currentTool, model.currentTool is EraserTool),
                   onToggle: () => model.callback(EraserTool(context)),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: ToolButton(
                   active: model.currentTool is LineTool,
                   icon: Icon(Icons.crop_square),
                   label: Text('Line Tool'),
                   options: _getToolOptions(model.currentTool, model.currentTool is LineTool),
                   onToggle: () => model.callback(LineTool(context)),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: ToolButton(
                   active: model.currentTool is ShapeTool,
                   icon: Icon(Icons.crop_square),
                   label: Text('Shape Tool'),
                   options: _getToolOptions(model.currentTool, model.currentTool is ShapeTool),
                   onToggle: () => model.callback(ShapeTool(context)),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: ToolButton(
                   active: model.currentTool is FillTool,
                   icon: Icon(Icons.crop_square),
                   label: Text('Fill Tool'),
                   options: _getToolOptions(model.currentTool, model.currentTool is FillTool),
                   onToggle: () => model.callback(FillTool(context)),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.all(6.0),
                 child: ToolButton(
                   active: model.currentTool is MarqueeSelectorTool,
                   icon: Icon(Icons.crop_square),
                   label: Text('Selection Tool'),
                   options: _getToolOptions(model.currentTool, model.currentTool is MarqueeSelectorTool),
                   onToggle: () => model.callback(MarqueeSelectorTool(context)),
                 ),
               ),
             ],
           ),
         );
      }
    );
  }
}
