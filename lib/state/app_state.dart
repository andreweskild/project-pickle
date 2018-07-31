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
    @required this.currentColor,
    this.currentLayerIndex = 0,
    @required this.layers,
    @required this.palette,
    @required this.previewLayer,
  });

  AppState copyWith({
    HSLColor currentColor,
    int currentLayerIndex,
    ToolType currentToolType = ToolType.pencil,
    List<PixelCanvasLayer> layers,
    List<HSLColor> palette,
    PixelCanvasLayer previewLayer,
  }) {
    return AppState(
      currentColor: currentColor ?? this.currentColor,
      currentLayerIndex: currentLayerIndex ?? this.currentLayerIndex,
      currentToolType: currentToolType ?? this.currentToolType,
      layers: layers ?? this.layers,
      palette: palette ?? this.palette,
      previewLayer: previewLayer ?? this.previewLayer,
    );
  }

  HSLColor currentColor;
  PixelCanvasLayer get currentLayer => layers[currentLayerIndex];
  int currentLayerIndex;
  ToolType currentToolType;
  List<PixelCanvasLayer> layers;
  final PixelCanvasLayer previewLayer;
  var palette = new List<HSLColor>();
}

AppState stateReducer(AppState state, dynamic action) {
  if (action is AddPixelAction) {
    state.previewLayer.setPixel(action.pos, state.currentColor.toColor());
    return state;
  } 
  else if (action is AddNewLayerAction) {
    state.layers.insert(
      state.currentLayerIndex + 1,
      new PixelCanvasLayer(
        name: action.name,
        height: 32,
        width: 32,
      )
    );
    state.currentLayerIndex += 1;
    return state;
  }
  else if (action is SetCurrentToolTypeAction) {
    return state.copyWith(
      currentToolType: action.toolType,
    );
  }
  else if (action is SetCurrentColorAction) {
    return state.copyWith(
      currentColor: HSLColor.from(action.color),
    );
  }
  else if (action is AddCurrentColorToPaletteAction) {
    List<HSLColor> newPalette = List.from(state.palette);
    newPalette.add(state.currentColor);
    return state.copyWith(
      palette: newPalette,
    );
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

