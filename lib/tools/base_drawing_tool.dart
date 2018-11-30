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

  List<Offset> _getEllipsePoints(Offset center, double x, double y) {
    var points = <Offset>[];
    points.add(Offset(center.dx + x, center.dy + y));
    points.add(Offset(center.dx - x, center.dy + y));
    points.add(Offset(center.dx + x, center.dy - y));
    points.add(Offset(center.dx - x, center.dy - y));
    return points;
  }

  // draws an ellipse based on center coordinate, vertical and horizontal Radii.
  List<Offset> _getEllipseStroke(Offset center, double xRadius, double yRadius) {
    var ellipseStroke = <Offset>[];
    double xRadiusSquared = math.pow(xRadius, 2.0);
    double yRadiusSquared = math.pow(yRadius, 2.0);
    double twoXRadiusSquared = 2 * xRadiusSquared;
    double twoYRadiusSquared = 2 * yRadiusSquared;

    double p;
    double x = 0.0;
    double y = yRadius;
    double pX = 0.0;
    double pY = twoXRadiusSquared * y;

    ellipseStroke.addAll(_getEllipsePoints(center, x, y));

    p = (yRadiusSquared - (xRadiusSquared * yRadius) + (0.25 * xRadiusSquared));
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

    p = (yRadiusSquared * (x + 0.5) * (x + 0.5) + xRadiusSquared * (y - 1) * (y - 1) - xRadiusSquared * yRadiusSquared);
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

  void _drawCircleToBuffer(Offset p1, Offset p2) {
    var topLeftBound;
    var bottomRightBound;
    List<Offset> ellipseStroke;
    Offset center;
    double xRadius, yRadius;

    // checks direction of drag to determine if points need to be flipped.
    // dragging to the right
    if(p1.dx < p2.dx) {
      // dragging down
      if(p1.dy < p2.dy) {
        topLeftBound = p1;
        bottomRightBound = p2;
        Offset distance = Offset((p1.dx - p2.dx).abs(), (p1.dy - p2.dy).abs());
        center = p1 + (distance/2.0);
        xRadius = p2.dx - center.dx;
        yRadius = p2.dy - center.dy;
        center = Offset(center.dx.roundToDouble(), center.dy.roundToDouble());
      }
      // dragging up
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
    // dragging to the left
    else {
      // dragging up
      if(p1.dy > p2.dy) {
        topLeftBound = p2;
        bottomRightBound = p1;
        Offset distance = Offset((topLeftBound.dx - bottomRightBound.dx).abs(), (topLeftBound.dy - bottomRightBound.dy).abs());
        center = topLeftBound + (distance/2.0);
        xRadius = bottomRightBound.dx - center.dx;
        yRadius = bottomRightBound.dy - center.dy;
        center = Offset(center.dx.floorToDouble(), center.dy.floorToDouble());
      }
      // dragging down
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

    ellipseStroke = _getEllipseStroke(center, xRadius, yRadius);
    drawPixelListToBuffer(ellipseStroke);

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
    var topLeftPoint = p1;
    var topRightPoint = Offset(p2.dx, p1.dy);
    var bottomLeftPoint = Offset(p1.dx, p2.dy);
    var bottomRightPoint = p2;
    drawPixelLineToBuffer(topLeftPoint, topRightPoint);
    drawPixelLineToBuffer(topRightPoint, bottomRightPoint);
    drawPixelLineToBuffer(bottomRightPoint, bottomLeftPoint);
    drawPixelLineToBuffer(bottomLeftPoint, topLeftPoint);
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