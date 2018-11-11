import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:project_pickle/state/app_state.dart';

typedef PixelInputCallback = void Function(Offset);
typedef OptionsBuilder = Widget Function();

abstract class BaseTool<T extends Widget> {
  BaseTool(
    BuildContext context,
  ) {
    store = StoreProvider.of<AppState>(context);
  }

  Store<AppState> store;

  bool get selectionIsPresent => store.state.selectionPath != null;

  bool pixelInSelection(Offset pos) {
    if(!selectionIsPresent) return true;
    else return store.state.selectionPath.contains(pos.translate(0.5, 0.5));
  }

  Offset _lastInputPos;

  Widget options;

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
    if (snappedX < 0) { snappedX = 0.0; }
    else if (snappedX > store.state.canvasWidth - 1) { snappedX = store.state.canvasWidth.toDouble() - 1; }
    if (snappedY < 0) { snappedY = 0.0; }
    else if (snappedY > store.state.canvasHeight - 1) { snappedY = store.state.canvasHeight.toDouble() - 1; }
    Offset snappedPos = Offset(snappedX, snappedY);
      onPixelInputUpdate(snappedPos);
    _lastInputPos = snappedPos;
  }
}