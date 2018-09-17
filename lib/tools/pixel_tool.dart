import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/base_drawing_tool.dart';

class PixelTool extends BaseDrawingTool {
  PixelTool(context) : super(context);

  Offset _lastPoint;

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
    if ( _lastPoint != null &&
        ((_lastPoint.dx - pos.dx).abs() > 1 ||
            (_lastPoint.dy - pos.dy).abs() > 1)) {
      drawOverlayPixelLine(_lastPoint, pos);
    }
    else {
      drawOverlayPixel(pos);
    }
    _lastPoint = pos;
  }

  @override
  void onPixelInputUp() {
    saveOverlayToLayer();
    _lastPoint = null;
  }

}