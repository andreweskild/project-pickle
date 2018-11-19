import 'package:flutter/material.dart' show RaisedButton, Theme, Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_drawing_tool.dart';
import 'package:project_pickle/widgets/common/toggle_button.dart';
import 'package:project_pickle/widgets/common/pushbutton_toggle_group.dart';

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

class ShapeOptionsModel {
  ShapeOptionsModel({
    this.filled,
    this.callback
  });

  final bool filled;
  final ValueChanged<bool> callback;

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + filled.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! ShapeOptionsModel) return false;
    ShapeOptionsModel model = other;
    return (model.filled == filled);
  }
}

class ShapeTool extends BaseDrawingTool {
  ShapeTool(context) : super(context);

  Offset _startPoint;
  Offset _endPoint;
  static bool _filled = false;


  Widget options = Column (
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
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
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
            child: StoreConnector<AppState, ShapeOptionsModel>(
              converter: (store) {
                return ShapeOptionsModel(
                  filled: store.state.shapeFilled,
                  callback: (filled) => store.dispatch(SetShapeFilledAction(filled)),
                );
              },
              builder: (context, model) {
                return SizedBox(
                  height: 40.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: ToggleButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.brightness_1), Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: Text('Stroke'),
                                  )
                                ],
                              ),
                              toggled: true,
                              onToggled: (value) {}
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: ToggleButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.brightness_1), Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: Text('Fill'),
                                  )
                                ],
                              ),
                              toggled: model.filled,
                              onToggled: model.callback
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            )
          )
        ],
      );

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
