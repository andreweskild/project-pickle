import 'package:flutter/widgets.dart';

import 'package:project_pickle/tools/base_drawing_tool.dart';
import 'package:project_pickle/widgets/common/switch.dart';

class ShapeTool extends BaseDrawingTool {
  ShapeTool(context) : super(context);

  Offset _startPoint;
  Offset _endPoint;

  get options => <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
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
          padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
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
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ];

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
      var topLeftPoint = _startPoint;
      var topRightPoint = Offset(_endPoint.dx, _startPoint.dy);
      var bottomLeftPoint = Offset(_startPoint.dx, _endPoint.dy);
      var bottomRightPoint = _endPoint;

      drawOverlayPixelLine(topLeftPoint, topRightPoint);
      drawOverlayPixelLine(topRightPoint, bottomRightPoint);
      drawOverlayPixelLine(bottomRightPoint, bottomLeftPoint);
      drawOverlayPixelLine(bottomLeftPoint, topLeftPoint);
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
