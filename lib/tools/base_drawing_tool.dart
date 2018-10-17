import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/tools/base_tool.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';

class BaseDrawingTool extends BaseTool<PixelCanvasLayer> {
  BaseDrawingTool(context)
    : super(
      context,
      PixelCanvasLayer(
        height: 32,
        width: 32
      )
    );


  void drawOverlayPixel(Offset pos) {
    if(pixelInSelection(pos)) {
      overlay.setPixel(pos, store.state.currentColor.toColor());
    }
  }

  void drawOverlayPixelLine(Offset p1, Offset p2) {
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
        drawOverlayPixel(new Offset(i, crossAxisPosition.round().toDouble()));
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
        drawOverlayPixel(new Offset(crossAxisPosition.round().toDouble(), i));
        crossAxisPosition = crossAxisPosition - slope;
      }
    }
  }

  void _drawEllipsePoints(Offset center, int x, int y) {
    drawOverlayPixel(Offset(center.dx + x, center.dy + y));
    drawOverlayPixel(Offset(center.dx - x, center.dy + y));
    drawOverlayPixel(Offset(center.dx + x, center.dy - y));
    drawOverlayPixel(Offset(center.dx - x, center.dy - y));
  }

  // draws an ellipse based on center coordinate, vertical and horizontal Radii.
  void _drawEllipse(Offset center, int xRadius, int yRadius) {
    int xRadiusSquared = math.pow(xRadius, 2);
    int yRadiusSquared = math.pow(yRadius, 2);
    int twoXRadiusSquared = 2 * xRadiusSquared;
    int twoYRadiusSquared = 2 * yRadiusSquared;

    int p;
    int x = 0;
    int y = yRadius;
    int pX = 0;
    int pY = twoXRadiusSquared * y;

    _drawEllipsePoints(center, x, y);

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
      _drawEllipsePoints(center, x, y);
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
      _drawEllipsePoints(center, x, y);
    }
  }

  void drawOverlayCircle(Offset p1, Offset p2) {
    Offset center;
//    double hRadius = (p1.dx - p2.dx).abs()/2.0;
//    double vRadius = (p1.dy - p2.dy).abs()/2.0;
    double hRadius, vRadius;

    // checks direction of drag to determine if points need to be flipped.
    // drag in right half
    if(p1.dx < p2.dx) {
      // drag in bottom half
      if(p1.dy < p2.dy) {
        Offset distance = Offset((p1.dx - p2.dx).abs(), (p1.dy - p2.dy).abs());
        center = p1 + (distance/2.0);
        hRadius = p2.dx - center.dx;
        vRadius = p2.dy - center.dy;
        center = Offset(center.dx.roundToDouble(), center.dy.roundToDouble());
      }
      // drag in top half
      else {
        var topLeftBound = Offset(p1.dx, p2.dy);
        var bottomRightBound = Offset(p2.dx, p1.dy);
        Offset distance = Offset((topLeftBound.dx - bottomRightBound.dx).abs(), (topLeftBound.dy - bottomRightBound.dy).abs());
        center = topLeftBound + (distance/2.0);
        hRadius = bottomRightBound.dx - center.dx;
        vRadius = bottomRightBound.dy - center.dy;
        center = Offset(center.dx.roundToDouble(), center.dy.floorToDouble());
      }
    }
    // drag in left half
    else {
      // drag in bottom half
      if(p1.dy > p2.dy) {
        var topLeftBound = p2;
        var bottomRightBound = p1;
        Offset distance = Offset((topLeftBound.dx - bottomRightBound.dx).abs(), (topLeftBound.dy - bottomRightBound.dy).abs());
        center = topLeftBound + (distance/2.0);
        hRadius = bottomRightBound.dx - center.dx;
        vRadius = bottomRightBound.dy - center.dy;
        center = Offset(center.dx.floorToDouble(), center.dy.roundToDouble());
      }
      // drag in top half
      else {
        var topLeftBound = Offset(p2.dx, p1.dy);
        var bottomRightBound = Offset(p1.dx, p2.dy);
        Offset distance = Offset((topLeftBound.dx - bottomRightBound.dx).abs(), (topLeftBound.dy - bottomRightBound.dy).abs());
        center = topLeftBound + (distance/2.0);
        hRadius = bottomRightBound.dx - center.dx;
        vRadius = bottomRightBound.dy - center.dy;
        center = Offset(center.dx.floorToDouble(), center.dy.floorToDouble());
      }
    }
    drawOverlayPixel(p1);
    drawOverlayPixel(p2);

    print(hRadius);
    print(vRadius);


    center = Offset(center.dx.floorToDouble(), center.dy.floorToDouble());
    _drawEllipse(center, hRadius.round(), vRadius.round());

//    Offset currentPixel = Offset(hRadius + center.dx, center.dy);
//
//    drawOverlayPixel(currentPixel);
//
//    currentPixel = Offset(center.dx, center.dy - vRadius);
//    drawOverlayPixel(currentPixel);
//    currentPixel = Offset(center.dx, center.dy + vRadius);
//    drawOverlayPixel(currentPixel);
//    currentPixel = Offset(center.dx - hRadius, center.dy);
//    drawOverlayPixel(currentPixel);
//

  }

  void _drawFilledRectToOverlay(Offset p1, Offset p2) {
    for (double x = p1.dx; x <= p2.dx; x++) {
      for (double y = p1.dy; y <= p2.dy; y++) {
        drawOverlayPixel(Offset(x, y));
      }
    }
  }


  void drawOverlayFilledRectangle(Offset p1, Offset p2) {
    if(p1.dx < p2.dx) {
      if(p1.dy < p2.dy) {
        _drawFilledRectToOverlay(p1, p2);
      }
      else {
        var newP1 = Offset(p1.dx, p2.dy);
        var newP2 = Offset(p2.dx, p1.dy);
        _drawFilledRectToOverlay(newP1, newP2);
      }
    }
    else {
      if(p1.dy > p2.dy) {
        var newP1 = p2;
        var newP2 = p1;
        _drawFilledRectToOverlay(newP1, newP2);
      }
      else {
        var newP1 = Offset(p2.dx, p1.dy);
        var newP2 = Offset(p1.dx, p2.dy);
        _drawFilledRectToOverlay(newP1, newP2);
      }
    }
  }


  void removePixel(Offset pos) {
    if(pixelInSelection(pos)) {
      store.dispatch(new RemovePixelAction(pos));
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

  void fillArea(Offset pos) {
    if (pixelInSelection(pos)) store.dispatch(new FillAreaAction(pos));
  }

  void resetOverlay() {
    overlay.clearPixels();
  }

  void saveOverlayToLayer() {
    store.dispatch(new SaveOverlayToLayerAction(overlay));
    resetOverlay();
  }

}