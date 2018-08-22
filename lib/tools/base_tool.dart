import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';

typedef PixelInputCallback = void Function(Offset);

abstract class BaseTool<T extends Widget> {
  BaseTool(
    BuildContext context,
    this.overlay,
  ) {
    store = StoreProvider.of<AppState>(context);
  }

  final T overlay;
  Store<AppState> store;

  Offset _lastInputPos;

  void onPixelInputUpdate(Offset pos) {}
  void onPixelInputUp() {}

  void handlePointerMove(details, BuildContext context) {
    RenderBox box = context.findRenderObject();
    var pos = box.globalToLocal(details.position);
    updateInputPosition(pos);
  }

  void handlePointerDown(details, BuildContext context) {
    RenderBox box = context.findRenderObject();
    var pos = box.globalToLocal(details.position);
    updateInputPosition(pos);
  }

  void handlePointerUp(details, BuildContext context) {
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