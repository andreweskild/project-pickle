import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

import 'package:project_pickle/tools/base_drawing_tool.dart';
import 'package:project_pickle/tools/base_tool.dart';
import 'package:project_pickle/widgets/common/switch.dart';
import 'package:project_pickle/widgets/common/toggle_icon_button.dart';

class ShapeTool extends BaseDrawingTool {
  ShapeTool(context) : super(context);

  Offset _startPoint;
  Offset _endPoint;
  static bool _filled = false;

  OptionsBuilder optionsBuilder = (isMini) {
    if(isMini) {
      return Column (
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
            child: SizedBox(
              height: 32.0,
              child: ToggleIconButton(
                  icon: Icon(Icons.access_alarm),
                  onToggled: (){}
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
            child: SizedBox(
              height: 32.0,
              child: ToggleIconButton(
                icon: Icon(Icons.account_balance),
                onToggled: (){_filled = !_filled;},
                toggled: _filled,
              ),
            ),
          ),
        ],
      );
    }
    else {
      return Column (
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 4.0, 0.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 4.0, 8.0, 4.0),
                  child: Text('Shape'),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Switch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 4.0, 4.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 4.0, 8.0, 4.0),
                  child: Text('Filled'),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Switch(
                      value: _filled,
                      onChanged: (value) {_filled = value;},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  };

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
//      if(_filled) {
//        drawOverlayFilledRectangle(_startPoint, _endPoint);
//      } else {
//        var topLeftPoint = _startPoint;
//        var topRightPoint = Offset(_endPoint.dx, _startPoint.dy);
//        var bottomLeftPoint = Offset(_startPoint.dx, _endPoint.dy);
//        var bottomRightPoint = _endPoint;
//
//        drawOverlayPixelLine(topLeftPoint, topRightPoint);
//        drawOverlayPixelLine(topRightPoint, bottomRightPoint);
//        drawOverlayPixelLine(bottomRightPoint, bottomLeftPoint);
//        drawOverlayPixelLine(bottomLeftPoint, topLeftPoint);
//      }
      drawOverlayCircle(_startPoint, _endPoint);
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
