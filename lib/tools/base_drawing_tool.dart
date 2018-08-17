import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_tool.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';

/// Mixin providing common operations for use with drawing tools.
///
/// Each function performs a specific operation, then sends the relevant data
/// to the store.
///
/// Use of this mixin requires the consuming class to initiate [store] and [overlay]
/// in its constructor.
class BaseDrawingTool extends BaseTool<PixelCanvasLayer> {
  BaseDrawingTool(context) : super(context) {
    _store = StoreProvider.of<AppState>(context);
    overlay = PixelCanvasLayer(height: 32, width: 32);
  }

  Store<AppState> _store;

  void drawOverlayPixel(Offset pos) {
    overlay.setPixel(pos, _store.state.currentColor.toColor());
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

  Color getPixelColor(Offset pos) {
    for (var layer in _store.state.layers.reversed) {
      if (layer.rawPixels.containsKey(pos)) {
        return layer.rawPixels[pos];
      }
    }

    return Colors.white;
  }

  void updateCurrentColor(Color color) {
    HSLColor hslColor = HSLColor.fromRGB(color);
    _store.dispatch(SetCurrentColorAction(hslColor));
  }

  void removePixel(Offset pos) {
    _store.dispatch(new RemovePixelAction(pos));
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
    _store.dispatch(new FillAreaAction(pos));
  }

  void resetOverlay() {
    overlay.clearPixels();
  }

  void saveOverlayToLayer() {
    _store.dispatch(new SaveOverlayToLayerAction(overlay));
    resetOverlay();
  }

}