import 'dart:ui' as dartUI;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';

class HueSlider extends StatefulWidget {
  HueSlider({
    Key key,
  }) : super(key: key);

  @override
  _HueSliderState createState() => new _HueSliderState();
}

class _HueSliderState extends State<HueSlider> {
  var color = new Color.fromRGBO(1, 0, 0, 1.0);
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, String>(
      converter: (store) => store.state.currentToolType.toString(),
      builder: (context, toolType) {
        return new Padding(
          padding: new EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          child: new Material(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(6.0),
            ),
              child: new SizedBox(
              height: 12.0,
              child: new GestureDetector(
                child: new CustomPaint(
                  willChange: true,
                  painter: new HueGradientPainter(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HueGradientPainter extends CustomPainter {
  HueGradientPainter(
  );

  @override
  void paint(Canvas canvas, Size size) {
    var hueGradient = new dartUI.Gradient.linear(
      new Offset(0.0, 0.0),
      new Offset(size.width, 0.0),
      <Color>[
        new Color(0xFFFF0000), //Red
        new Color(0xFFFFFF00), //Yellow
        new Color(0xFF00FF00), //Green
        new Color(0xFF00FFFF), //Cyan
        new Color(0xFF0000FF), //Blue
        new Color(0xFFFF00FF), //Violet
        new Color(0xFFFF0000), //Red
      ],
      <double>[
        0.0, 0.166, 0.333, 0.5, 0.666, 0.833, 1.0
      ]
    );

    var _colorPaint = new Paint()
      ..shader = hueGradient;

    canvas.drawRect(
      new Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      _colorPaint
    );
  }

  @override
  bool shouldRepaint(HueGradientPainter oldDelegate) => true;
}