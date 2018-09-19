import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/base_drawing_tool.dart';

class ShapeTool extends BaseDrawingTool {
  ShapeTool(context) : super(context);

  Offset _startPoint;
  Offset _endPoint;

  get options => <Widget>[
    Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
            child: Text('Size'),
          ),
          Slider(
            min: 0.0,
            max: 1.0,
            value: 0.0,
            onChanged: (value){},
          ),
          SizedBox(
            width: 20.0,
            child: Center(
              child: TextField(
                  maxLength: 3,
                  decoration: null
              ),
            ),
          )
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 4.0),
        child: Text('Shape')
    ),
  ];

  @override
  void onPixelInputUpdate(Offset pos) {
    if (_startPoint == null) {
      _startPoint = pos;
      drawOverlayPixel(pos);
    }
    else {
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