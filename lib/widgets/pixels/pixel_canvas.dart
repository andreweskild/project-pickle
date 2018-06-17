import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/data_objects/pixel.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/line_tool.dart';
import 'package:project_pickle/tools/pencil_tool.dart';
import 'package:project_pickle/tools/tool.dart';
import 'package:project_pickle/widgets/pixels/pixel_painter.dart';

class PixelChangeNotifier extends ChangeNotifier {
  PixelChangeNotifier();
}


class PixelCanvas extends StatefulWidget {
  PixelCanvas({
    Key key,
  }) : super(key: key);
  final _notifier = new PixelChangeNotifier();


  var _pixels = <Pixel>[];
  var _previewPixels = <Pixel>[];
  var _redoPixels = <Pixel>[];


  void setPixel(double x, double y, Color color) {
    _previewPixels.add(new Pixel(x, y, color));
    _notifier.notifyListeners();
  }

  void setPixelsFromLine(Offset p1, Offset p2, Color color) {
    _previewPixels.clear();
    var horizontalMovement = (p1.dx - p2.dx).abs();
    var verticalMovement = (p1.dy - p2.dy).abs();

    // if line is more horizontal
    if(horizontalMovement >= verticalMovement) {
      // if start is higher
      if (p1.dx > p2.dx) {
        // swap points
        var tempOffset = p1;
        p1 = p2;
        p2 = tempOffset;
      }
      var slope = (p2.dy - p1.dy) / (p2.dx - p1.dx);
      var crossAxisPosition = p1.dy;
      for (double i = p1.dx; i <= p2.dx; i++) {
        setPixel(i, crossAxisPosition.round().toDouble(), color);
        crossAxisPosition = crossAxisPosition + slope;
      }
    }
    else {
      // if start is higher
      if (p1.dy < p2.dy) {
        // swap points
        var tempOffset = p1;
        p1 = p2;
        p2 = tempOffset;
      }
      var slope = (p2.dx - p1.dx) / (p2.dy - p1.dy);
      var crossAxisPosition = p1.dx;
      for (double i = p1.dy; i >= p2.dy; i--) {
        setPixel(crossAxisPosition.round().toDouble(), i, color);
        crossAxisPosition = crossAxisPosition - slope;
      }
    }
  }

  void finalizePixels() {
    _pixels.addAll(_previewPixels);
    _previewPixels.clear();
    _notifier.notifyListeners();
  }

  @override
  _PixelCanvasState createState() => new _PixelCanvasState();
}

class _PixelCanvasState extends State<PixelCanvas> {
  Tool _currentTool;

  @override
  Widget build(BuildContext context) {


    return new StoreConnector<AppState, ToolType>(
            converter: (store) => store.state.currentToolType,
            builder: (context, toolType) {
              switch (toolType) {
                case ToolType.line: 
                  _currentTool = new LineTool(context, widget);
                  break;
                case ToolType.pencil: 
                  _currentTool = new PencilTool(context, widget);
                  break;
              }
              return new GestureDetector(
                onPanUpdate: (details) {
                  _currentTool.handlePanUpdate(details);
                },
                onPanDown: (details) {
                  _currentTool.handlePanDown(details);
                },
                onPanEnd: (details) {
                  _currentTool.handlePanEnd(details);
                },
                onTapUp: (details) {
                  _currentTool.handleTapUp(details);
                },
                child: SizedBox(
                  width: 32.0,
                  height: 32.0,
                  child: DecoratedBox(
                    decoration: new BoxDecoration(
                      color: Colors.white
                    ),
                    child: new CustomPaint(
                      willChange: true,
                      painter: new PixelPainter(widget._pixels, widget._previewPixels, widget._notifier),
                    ),
                  ),
                ),
              );
            },
          );
  }
}