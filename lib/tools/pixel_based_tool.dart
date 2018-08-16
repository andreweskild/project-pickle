import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:project_pickle/tools/tool.dart';

typedef PixelInputCallback = void Function(Offset);

abstract class PixelBasedTool extends Tool {
  PixelBasedTool(
    BuildContext context,
    Widget overlay
  ) : super(context, overlay);

  Offset _lastInputPos;

  void _onPixelInputUpdate(Offset pos) {}
  void _onPixelInputUp() {}

  void handlePointerMove(details) {
    RenderBox box = context.findRenderObject();
    var pos = box.globalToLocal(details.position);
    updateInputPosition(pos);
  }

  void handlePointerDown(details) {
    RenderBox box = context.findRenderObject();
    var pos = box.globalToLocal(details.position);
    updateInputPosition(pos);
  }

  void handlePointerUp(details) {
    _onPixelInputUp();
  }

  void updateInputPosition(Offset pos) {
    double snappedX = pos.dx.floorToDouble();
    double snappedY = pos.dy.floorToDouble();
    Offset snappedPos = Offset(snappedX, snappedY);
    if (_lastInputPos == null ||
        snappedPos != _lastInputPos) {
      _onPixelInputUpdate(pos);
    }
    _lastInputPos = snappedPos;
  }
}