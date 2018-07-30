import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:project_pickle/data_objects/pixel_layer.dart';
import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas_layer.dart';

class AddCurrentColorToPaletteAction {
  AddCurrentColorToPaletteAction();
}

class AddNewLayerAction {
  AddNewLayerAction(this.name);
  final String name;
}

class SetCurrentToolTypeAction {
  SetCurrentToolTypeAction(this.toolType);
  final ToolType toolType;
}

class SetCurrentColorAction {
  SetCurrentColorAction(this.color);
  final HSLColor color;
}


class AddPixelAction {
  AddPixelAction(
    this.pos,
  );

  final Offset pos;
}

class RemovePixelAction {
  RemovePixelAction(
      this. pos,
      );
  final Offset pos;
}

class ClearPreviewAction {
  ClearPreviewAction();
}

class FillAreaAction {
  FillAreaAction(this.pos);
  final Offset pos;
}

class FinalizePixelsAction {
  FinalizePixelsAction();
}

class SetCurrentLayerIndexAction {
  SetCurrentLayerIndexAction(
    this.currentLayerIndex,
  );
  final int currentLayerIndex;
}

class AppState {
  AppState({
    this.currentToolType = ToolType.pencil,
    this.currentColor,
    this.palette,
  }) {
    currentLayerIndex = 0;
  }

  AppState.copyWith({
    this.currentColor,
    this.currentLayerIndex,
    this.currentToolType = ToolType.pencil,
    this.layers,
    this.palette,
  });

  HSLColor currentColor;
  PixelCanvasLayer get currentLayer => layers[currentLayerIndex];
  int currentLayerIndex;
  ToolType currentToolType;
  var layers = <PixelCanvasLayer>[new PixelCanvasLayer(name: 'Layer 1', height: 32, width: 32,)];
  final previewLayer = new PixelCanvasLayer(height: 32, width: 32,);
  var palette = new List<HSLColor>();
}

AppState stateReducer(AppState state, dynamic action) {
  if (action is AddPixelAction) {
    state.previewLayer.setPixel(action.pos, state.currentColor.toColor());
    return state;
  } 
  else if (action is AddNewLayerAction) {
    state.layers.add(
      new PixelCanvasLayer(
        name: action.name,
        height: 32,
        width: 32,
      )
    );
    return state;
  }
  else if (action is SetCurrentToolTypeAction) {
    state.currentToolType = action.toolType;
    return state;
  }
  else if (action is SetCurrentColorAction) {
    state.currentColor = new HSLColor.from(action.color);
    return state;
  }
  else if (action is AddCurrentColorToPaletteAction) {
    state.palette.add(state.currentColor);
    return state;
  }
  else if (action is ClearPreviewAction) {
    state.previewLayer.clearPixels();
    return state;
  }
  else if (action is SetCurrentLayerIndexAction) {
    if (action.currentLayerIndex < state.layers.length) {
      state.currentLayerIndex = action.currentLayerIndex;
    }
    return state;
  }
  else if (action is RemovePixelAction) {
    state.currentLayer.removePixel(action.pos);
    return state;
  }
  else if (action is FinalizePixelsAction) {
    state.currentLayer.setPixelsFromMap(state.previewLayer.rawPixels);
    state.previewLayer.clearPixels();
    return state;
  }
  else if (action is FillAreaAction) {
    state.currentLayer.fillArea(
      action.pos,
      state.currentColor.toColor()
    );
    return state;
  }
  else {
    return state;
  }
}

