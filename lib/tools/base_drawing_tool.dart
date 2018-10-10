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