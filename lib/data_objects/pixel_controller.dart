import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


import '../elements/pixel_canvas.dart';
import '../state/app_state.dart';
import '../tools/line_tool.dart';
import '../tools/pencil_tool.dart';
import '../tools/tool.dart';
import '../tools/tool_types.dart';

class Pixel extends Rect {
  Color color;

  Pixel(double x, double y, this.color)
    : super.fromLTWH(x, y, 1.0, 1.0);
}

class PixelChangeNotifier extends ChangeNotifier {
  PixelChangeNotifier();
}


class PixelController extends StatefulWidget {
  PixelController({
    Key key,
  }) : super(key: key);
  final _notifier = new PixelChangeNotifier();
  final toolsNotifier;


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
  _PixelControllerState createState() => new _PixelControllerState();
}

class _PixelControllerState extends State<PixelController> {
  var _currentToolType = ToolType.line;
  Tool _currentTool;

  void setCurrentTool(ToolType toolType) {
    setState((){
      _currentToolType = toolType;
    });
  }

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
                  _currentTool = new PixelTool(context, widget);
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
                      painter: new PixelCanvas(widget._pixels, widget._previewPixels, widget._notifier),
                    ),
                  ),
                ),
              );
            },
          );
  }
}