import 'dart:ui' as dartUI;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';


class ColorChangeNotifier extends ChangeNotifier {
  ColorChangeNotifier();
}

class ColorSelectionRect extends StatefulWidget {
  ColorSelectionRect({
    Key key,
  }) : super(key: key);
  final _notifier = new ColorChangeNotifier();

  @override
  _ColorSelectionRectState createState() => new _ColorSelectionRectState();
}

class _ColorSelectionRectState extends State<ColorSelectionRect> {
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
              child: new AspectRatio(
              aspectRatio: 1.33,
              child: new GestureDetector(
                child: new CustomPaint(
                  willChange: true,
                  painter: new ColorGradientPainter(new Color.fromRGBO(1, 0, 0, 1.0), widget._notifier),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ColorGradientPainter extends CustomPainter {
  ColorGradientPainter(
    this.color,
    ColorChangeNotifier notifier
  ) : super(repaint: notifier);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {

    var saturationGradient = new dartUI.Gradient.linear(
      new Offset(0.0, 0.0),
      new Offset(size.width, 0.0),
      <Color>[
        new Color(0xFFFFFFFF),
        color,
      ],
    );

    var valueGradient = new dartUI.Gradient.linear(
      new Offset(0.0, 0.0),
      new Offset(0.0, size.height),
      <Color>[
        new Color(0x00000000),
        new Color(0xFF000000),
      ],
    );

    canvas.drawRect(
      new Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      new Paint()
      ..shader = saturationGradient,
    );

    canvas.drawRect(
      new Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      new Paint()
      ..shader = valueGradient,
    );
  }

  @override
  bool shouldRepaint(ColorGradientPainter oldDelegate) => true;
}