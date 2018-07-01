import 'package:flutter/material.dart';

import 'package:project_pickle/data_objects/pixel_layer.dart';
import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/data_objects/tool_types.dart';

class SetCurrentToolTypeAction {
  final ToolType toolType;

  SetCurrentToolTypeAction(this.toolType);
}

class SetCurrentColorAction {
  final HSLColor color;

  SetCurrentColorAction(this.color);
}

class AddCurrentColorToPaletteAction {
  AddCurrentColorToPaletteAction();
}

class AddPixelAction {
  AddPixelAction(
    this.pos,
    this.color
  );

  final Offset pos;
  final Color color;
}

class SetCurrentLayerAction {
  SetCurrentLayerAction(
    this.currentLayerIndex,
  );

  final int currentLayerIndex;
}

class AppState {
  AppState({
    this.currentToolType = ToolType.pencil,
    this.currentColor,
    this.palette,
    this.currentLayer,
  });

  ToolType currentToolType;
  HSLColor currentColor;
  PixelLayer currentLayer;

  List<HSLColor> palette = new List<HSLColor>();
  List<PixelLayer> layers = <PixelLayer>[new PixelLayer('Layer 1')];
}

AppState stateReducer(AppState state, dynamic action) {
  if (action is SetCurrentToolTypeAction) {
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
  else if (action is AddPixelAction) {
    state.currentLayer.pixels[action.pos] = action.color;
    return state;
  }
  else if (action is SetCurrentLayerAction) {
    if (action.currentLayerIndex < state.layers.length) {
        state.currentLayer = state.layers[action.currentLayerIndex];
    }
    return state;
  }
  else {
    return state;
  }
}
