import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/tools/base_tool.dart';

class BaseDrawingTool extends BaseTool {
  BaseDrawingTool(context)
    : super(
      context
    );


  void drawPixelToBuffer(Offset pos) {
    if(pixelInSelection(pos)) {
      store.state.drawingBuffer.addPixel(pos.dx.toInt(), pos.dy.toInt());
    }
  }

  void drawPixelListToBuffer(List<Offset> posList) {
    posList.forEach(
      (pos) {
        drawPixelToBuffer(pos);
      }
    );
  }

  void drawPixelLineToBuffer(Offset p1, Offset p2) {
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
        drawPixelToBuffer(new Offset(i, crossAxisPosition.round().toDouble()));
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
        drawPixelToBuffer(new Offset(crossAxisPosition.round().toDouble(), i));
        crossAxisPosition = crossAxisPosition - slope;
      }
    }
  }

  List<Offset> _getEllipsePoints(Offset center, int x, int y) {
    var points = <Offset>[];
    points.add(Offset(center.dx + x, center.dy + y));
    points.add(Offset(center.dx - x, center.dy + y));
    points.add(Offset(center.dx + x, center.dy - y));
    points.add(Offset(center.dx - x, center.dy - y));
    return points;
  }

  // draws an ellipse based on center coordinate, vertical and horizontal Radii.
  List<Offset> _getEllipseStroke(Offset center, int xRadius, int yRadius) {
    var ellipseStroke = <Offset>[];
    int xRadiusSquared = math.pow(xRadius, 2);
    int yRadiusSquared = math.pow(yRadius, 2);
    int twoXRadiusSquared = 2 * xRadiusSquared;
    int twoYRadiusSquared = 2 * yRadiusSquared;

    int p;
    int x = 0;
    int y = yRadius;
    int pX = 0;
    int pY = twoXRadiusSquared * y;

    ellipseStroke.addAll(_getEllipsePoints(center, x, y));

    p = (yRadiusSquared - (xRadiusSquared * yRadius) + (0.25 * xRadiusSquared)).round();
    while (pX < pY) {
      x++;
      pX += twoYRadiusSquared;
      if(p < 0) {
        p += yRadiusSquared + pX;
      } else {
        y--;
        pY -= twoXRadiusSquared;
        p += yRadiusSquared + pX - pY;
      }
      ellipseStroke.addAll(_getEllipsePoints(center, x, y));
    }

    p = (yRadiusSquared * (x + 0.5) * (x + 0.5) + xRadiusSquared * (y - 1) * (y - 1) - xRadiusSquared * yRadiusSquared).round();
    while (y > 0) {
      y--;
      pY -= twoXRadiusSquared;
      if(p > 0) {
        p += xRadiusSquared - pY;
      } else {
        x++;
        pX += twoYRadiusSquared;
        p += xRadiusSquared - pY + pX;
      }
      ellipseStroke.addAll(_getEllipsePoints(center, x, y));
    }

    return ellipseStroke;
  }

  List<Offset> _getEllipseFill(Offset center, int xRadius, int yRadius) {
    var topLeft = Offset(center.dx - xRadius, center.dy - yRadius);
    var bottomRight = Offset(center.dx + xRadius, center.dy + yRadius);
    var ellipseFill = <Offset>[];
    bool isPointInEllipse(Offset point) {
      return math.pow((point.dx - center.dx), 2) / math.pow(xRadius, 2) +
        math.pow((point.dy - center.dy), 2) / math.pow(yRadius, 2) <= 1;
    }

    for (double x = topLeft.dx; x < bottomRight.dx; x++) {
      for (double y = topLeft.dy; y < bottomRight.dy; y++) {
        if(isPointInEllipse(Offset(x, y))) {
          ellipseFill.add(Offset(x, y));
        }
      }
    }

    return ellipseFill;
  }

  void _drawCircleToBuffer(Offset p1, Offset p2) {
    var topLeftBound;
    var bottomRightBound;
    List<Offset> ellipseStroke;
    List<Offset> ellipseFill;
    Offset center;
    double xRadius, yRadius;

    // checks direction of drag to determine if points need to be flipped.
    // drag in right half
    if(p1.dx < p2.dx) {
      // drag in bottom half
      if(p1.dy < p2.dy) {
        topLeftBound = p1;
        bottomRightBound = p2;
        Offset distance = Offset((p1.dx - p2.dx).abs(), (p1.dy - p2.dy).abs());
        center = p1 + (distance/2.0);
        xRadius = p2.dx - center.dx;
        yRadius = p2.dy - center.dy;
        center = Offset(center.dx.roundToDouble(), center.dy.roundToDouble());
      }
      // drag in top half
      else {
        topLeftBound = Offset(p1.dx, p2.dy);
        bottomRightBound = Offset(p2.dx, p1.dy);
        Offset distance = Offset((topLeftBound.dx - bottomRightBound.dx).abs(), (topLeftBound.dy - bottomRightBound.dy).abs());
        center = topLeftBound + (distance/2.0);
        xRadius = bottomRightBound.dx - center.dx;
        yRadius = bottomRightBound.dy - center.dy;
        center = Offset(center.dx.roundToDouble(), center.dy.floorToDouble());
      }
    }
    // drag in left half
    else {
      // drag in top half
      if(p1.dy > p2.dy) {
        topLeftBound = p2;
        bottomRightBound = p1;
        Offset distance = Offset((topLeftBound.dx - bottomRightBound.dx).abs(), (topLeftBound.dy - bottomRightBound.dy).abs());
        center = topLeftBound + (distance/2.0);
        xRadius = bottomRightBound.dx - center.dx;
        yRadius = bottomRightBound.dy - center.dy;
        center = Offset(center.dx.floorToDouble(), center.dy.floorToDouble());
      }
      // drag in bottom half
      else {
        topLeftBound = Offset(p2.dx, p1.dy);
        bottomRightBound = Offset(p1.dx, p2.dy);
        Offset distance = Offset((topLeftBound.dx - bottomRightBound.dx).abs(), (topLeftBound.dy - bottomRightBound.dy).abs());
        center = topLeftBound + (distance/2.0);
        xRadius = bottomRightBound.dx - center.dx;
        yRadius = bottomRightBound.dy - center.dy;
        center = Offset(center.dx.floorToDouble(), center.dy.roundToDouble());
      }
    }

    if(store.state.shapeFilled) {
      ellipseFill = _getEllipseFill(center, xRadius.round(), yRadius.round());
      drawPixelListToBuffer(ellipseFill);
    }

    ellipseStroke = _getEllipseStroke(center, xRadius.round(), yRadius.round());
    drawPixelListToBuffer(ellipseStroke);

  }

  void _drawFilledRectToBuffer(Offset p1, Offset p2) {
    for (double x = p1.dx; x <= p2.dx; x++) {
      for (double y = p1.dy; y <= p2.dy; y++) {
        drawPixelToBuffer(Offset(x, y));
      }
    }
  }

  void drawShapeToBuffer(Offset p1, Offset p2) {
    switch(store.state.toolShape) {
      case ShapeMode.Rectangle: _drawRectangleToBuffer(p1, p2);
      break;
      case ShapeMode.Circle: _drawCircleToBuffer(p1, p2);
      break;
      case ShapeMode.Triangle: _drawCircleToBuffer(p1, p2);
      break;
    }
  }

  void _drawRectangleToBuffer(Offset p1, Offset p2) {
    if(store.state.shapeFilled) {
      _drawOverlayFilledRectangle(p1, p2);
    } else {
      var topLeftPoint = p1;
      var topRightPoint = Offset(p2.dx, p1.dy);
      var bottomLeftPoint = Offset(p1.dx, p2.dy);
      var bottomRightPoint = p2;

      drawPixelLineToBuffer(topLeftPoint, topRightPoint);
      drawPixelLineToBuffer(topRightPoint, bottomRightPoint);
      drawPixelLineToBuffer(bottomRightPoint, bottomLeftPoint);
      drawPixelLineToBuffer(bottomLeftPoint, topLeftPoint);
    }
  }

  void _drawOverlayFilledRectangle(Offset p1, Offset p2) {
    if(p1.dx < p2.dx) {
      if(p1.dy < p2.dy) {
        _drawFilledRectToBuffer(p1, p2);
      }
      else {
        var newP1 = Offset(p1.dx, p2.dy);
        var newP2 = Offset(p2.dx, p1.dy);
        _drawFilledRectToBuffer(newP1, newP2);
      }
    }
    else {
      if(p1.dy > p2.dy) {
        var newP1 = p2;
        var newP2 = p1;
        _drawFilledRectToBuffer(newP1, newP2);
      }
      else {
        var newP1 = Offset(p2.dx, p1.dy);
        var newP2 = Offset(p1.dx, p2.dy);
        _drawFilledRectToBuffer(newP1, newP2);
      }
    }
  }


  void removePixel(Offset pos) {
    if(pixelInSelection(pos)) {
      store.dispatch(RemovePixelAction(pos));
    }
  }


  void removePixelLine(Offset p1, Offset p2) {
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
        removePixel(new Offset(i, crossAxisPosition.round().toDouble()));
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
        removePixel(new Offset(crossAxisPosition.round().toDouble(), i));
        crossAxisPosition = crossAxisPosition - slope;
      }
    }
  }

  void startEraserAction() {
    store.dispatch(EraseStartAction());
  }

  void endEraserAction() {
    store.dispatch(EraseEndAction());
  }

  void fillArea(Offset pos) {
    if (pixelInSelection(pos)) store.dispatch(new FillAreaAction(pos));
  }

  void clearBuffer() {
    store.state.drawingBuffer.clearBuffer();
  }

  void finalizeBuffer() {
    store.dispatch(new FinalizePixelBufferAction());
    clearBuffer();
  }

}