import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/tool.dart';
import 'package:project_pickle/tools/pixel_based_tool.dart';

class BaseDrawingTool extends PixelBasedTool {
  BaseDrawingTool({
    Key key,
    BuildContext context,
    Widget overlay
  }) : super(context, overlay);

  Store<AppState> _store;

  void drawPreviewPixel(Offset pos) {
    _store.dispatch(new AddPixelAction(pos));
  }

  void drawPreviewPixelLine(Offset p1, Offset p2) {
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
        drawPreviewPixel(new Offset(i, crossAxisPosition.round().toDouble()));
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
        drawPreviewPixel(new Offset(crossAxisPosition.round().toDouble(), i));
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

  void resetPreview() {
    _store.dispatch(new ClearPreviewAction());
  }

  void finalizePreview() {
    _store.dispatch(new FinalizePixelsAction());
  }

}