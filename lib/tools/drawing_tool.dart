import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'package:project_pickle/tools/tool.dart';

class DrawingTool extends Tool {
  Stream<Offset> drawUpdate;
  StreamController<Offset> _drawUpdateController;
  VoidCallback onDrawFinished;

  void handleDrawPosUpdate(Offset pos) => {};
  void handleDrawEnd() => {};
  
  DrawingTool() {
    _drawUpdateController = new StreamController();
    drawUpdate = _drawUpdateController.stream;
  }

  void addPixel(Offset pos) {
    _drawUpdateController.add(pos);
  }

  void addPixelLine(Offset p1, Offset p2) {
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
        addPixel(new Offset(i, crossAxisPosition.round().toDouble()));
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
        addPixel(new Offset(crossAxisPosition.round().toDouble(), i));
        crossAxisPosition = crossAxisPosition - slope;
      }
    }
  }

}