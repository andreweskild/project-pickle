import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:project_pickle/tools/tool_old.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';

typedef PixelInputCallback = void Function(Offset);

abstract class BaseTool<T extends Widget> {
  BaseTool(
    this.context,
  );

  final BuildContext context;
  T overlay;
  Offset _lastInputPos;

  void onPixelInputUpdate(Offset pos) {}
  void onPixelInputUp() {}

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
    onPixelInputUp();
  }

  void updateInputPosition(Offset pos) {
    double snappedX = pos.dx.floorToDouble();
    double snappedY = pos.dy.floorToDouble();
    Offset snappedPos = Offset(snappedX, snappedY);
    if (_lastInputPos == null ||
        snappedPos != _lastInputPos) {
      onPixelInputUpdate(snappedPos);
    }
    _lastInputPos = snappedPos;
  }
}