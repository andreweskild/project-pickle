import 'package:flutter/material.dart' show RaisedButton, Theme, Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_drawing_tool.dart';
import 'package:project_pickle/tools/base_tool.dart';
import 'package:project_pickle/widgets/common/toggle_button.dart';
import 'package:project_pickle/widgets/common/pushbutton_toggle_group.dart';
import 'package:project_pickle/widgets/common/raised_dropdown_button.dart';
import 'package:project_pickle/widgets/common/switch.dart';
import 'package:project_pickle/widgets/common/toggle_button.dart';

class ShapeModel {
  ShapeModel({
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
    if (other is! ShapeModel) return false;
    ShapeModel model = other;
    return (model.shape == shape);
  }
}

class FilledShapeModel {
  FilledShapeModel({
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
    if (other is! FilledShapeModel) return false;
    FilledShapeModel model = other;
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
            child: StoreConnector<AppState,ShapeModel>(
              converter: (store) {
                return ShapeModel(
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
            child: SizedBox(
              height: 40.0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: ToggleButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[Icon(Icons.brightness_1), Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text('Stroke'),
                          )],
                        ),
                        toggled: true,
                        onToggled: (value){}
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: ToggleButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[Icon(Icons.brightness_1), Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text('Fill'),
                            )],
                          ),
                          toggled: false,
                          onToggled: (value){}
                      ),
                    ),
                  ),
                ],
              ),
            )
          )
        ],
      );

  @override
  void onPixelInputUpdate(Offset pos) {
    if (_startPoint == null) {
      _startPoint = pos;
      drawOverlayPixel(pos);
    } else {
      if (_endPoint != null) {
        resetOverlay();
      }
      _endPoint = pos;
      drawShapeToOverlay(_startPoint, _endPoint);
    }
  }

  @override
  void onPixelInputUp() {
    saveOverlayToLayer();
    resetLinePoints();
  }

  void resetLinePoints() {
    _startPoint = null;
    _endPoint = null;
  }

}
