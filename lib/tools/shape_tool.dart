import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_drawing_tool.dart';
import 'package:project_pickle/widgets/common/pushbutton_toggle_group.dart';
import 'package:project_pickle/widgets/common/two_stage_popup_button.dart';

class ShapeModeModel {
  ShapeModeModel({
    this.shape,
    this.callback
  });

  final ShapeMode shape;
  final ValueChanged<ShapeMode> callback;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + shape.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! ShapeModeModel) return false;
    ShapeModeModel model = other;
    return (model.shape == shape);
  }
}

class ShapeTool extends BaseDrawingTool {
  ShapeTool(context) : super(context);

  Offset _startPoint;
  Offset _endPoint;


  List<PopupContentItem> options = <PopupContentItem>[
          PopupContentItem(
            child: StoreConnector<AppState,ShapeModeModel>(
              converter: (store) {
                return ShapeModeModel(
                  shape: store.state.toolShape,
                  callback: (value) => store.dispatch(SetToolShapeAction(value)),
                );
              },
              builder: (context, model) {
                return PushbuttonToggleGroup<ShapeMode>(
                  value: model.shape,
                  onChanged: model.callback,
                  items: <PushbuttonToggle<ShapeMode>>[
                    PushbuttonToggle<ShapeMode>(
                      child: Icon(Icons.crop_square),
                      value: ShapeMode.Rectangle
                    ),
                    PushbuttonToggle<ShapeMode>(
                        child: Icon(Icons.brightness_1),
                        value: ShapeMode.Circle
                    ),
                    PushbuttonToggle<ShapeMode>(
                        child: Icon(Icons.change_history),
                        value: ShapeMode.Triangle
                    ),
                  ],
                );
              }
            ),
          ),
        ];

  @override
  void onPixelInputUpdate(Offset pos) {
    if (_startPoint == null) {
      _startPoint = pos;
      drawPixelToBuffer(pos);
    } else {
      if (_endPoint != null) {
        clearBuffer();
      }
      _endPoint = pos;
      drawShapeToBuffer(_startPoint, _endPoint);
    }
  }

  @override
  void onPixelInputUp() {
    finalizeBuffer();
    resetLinePoints();
  }

  void resetLinePoints() {
    _startPoint = null;
    _endPoint = null;
  }

}
