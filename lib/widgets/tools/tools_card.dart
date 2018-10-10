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

Widget _getToolOptions(dynamic currentTool, bool isCurrentToolType, bool isMini) {
  return (isCurrentToolType && currentTool.optionsBuilder != null)
      ? currentTool.optionsBuilder(isMini) : SizedBox();
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
        return ExpandableButtonList(
          expansionCallback: (index, expanded) {
            if(!expanded){
              model.callback(_createToolFromIndex(context, index));
            }
          },
          children: <ExpandableButton>[
            ToolListButton(
              isExpanded: model.currentTool is PixelTool,
              icon: Icons.crop_square ,
              label: 'Pixel',
              options: _getToolOptions(model.currentTool, model.currentTool is PixelTool, model.sizeMode == DrawerSizeMode.Mini),
              isMini: model.sizeMode == DrawerSizeMode.Mini
            ),
            ToolListButton(
              isExpanded: model.currentTool is EraserTool,
              icon: Icons.crop_square ,
              label: 'Eraser',
              options: _getToolOptions(model.currentTool, model.currentTool is EraserTool, model.sizeMode == DrawerSizeMode.Mini),
              isMini: model.sizeMode == DrawerSizeMode.Mini
            ),
            ToolListButton(
              isExpanded: model.currentTool is LineTool,
              icon: Icons.crop_square ,
              label: 'Line',
              options: _getToolOptions(model.currentTool, model.currentTool is LineTool, model.sizeMode == DrawerSizeMode.Mini),
              isMini: model.sizeMode == DrawerSizeMode.Mini
            ),
            ToolListButton(
              isExpanded: model.currentTool is ShapeTool,
              icon: Icons.crop_square ,
              label: 'Shape',
              options: _getToolOptions(model.currentTool, model.currentTool is ShapeTool, model.sizeMode == DrawerSizeMode.Mini),
              isMini: model.sizeMode == DrawerSizeMode.Mini
            ),
            ToolListButton(
              isExpanded: model.currentTool is FillTool,
              icon: Icons.crop_square ,
              label: 'Fill',
              options: _getToolOptions(model.currentTool, model.currentTool is FillTool, model.sizeMode == DrawerSizeMode.Mini),
              isMini: model.sizeMode == DrawerSizeMode.Mini
            ),
            ToolListButton(
              isExpanded: model.currentTool is MarqueeSelectorTool,
              icon: Icons.crop_square ,
              label: 'Selection',
              options: _getToolOptions(model.currentTool, model.currentTool is MarqueeSelectorTool, model.sizeMode == DrawerSizeMode.Mini),
              isMini: model.sizeMode == DrawerSizeMode.Mini
            ),
          ],
        );
      }
    );
  }
}
