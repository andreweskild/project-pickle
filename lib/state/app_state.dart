import 'package:flutter/material.dart';

import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/widgets/pixels/pixel_canvas_layer.dart';

class AppState {
  AppState({
    this.canvasScale = 1.0,
    this.currentToolType = ToolType.pencil,
    @required this.currentColor,
    this.currentLayerIndex = 0,
    @required this.layers,
    @required this.palette,
    @required this.previewLayer,
    this.selectionPath,
  });

  AppState copyWith({
    double canvasScale,
    HSLColor currentColor,
    int currentLayerIndex,
    ToolType currentToolType,
    List<PixelCanvasLayer> layers,
    List<HSLColor> palette,
    PixelCanvasLayer previewLayer,
    Path selectionPath,
  }) {
    return AppState(
      canvasScale: canvasScale ?? this.canvasScale,
      currentColor: currentColor ?? this.currentColor,
      currentLayerIndex: currentLayerIndex ?? this.currentLayerIndex,
      currentToolType: currentToolType ?? this.currentToolType,
      layers: layers ?? this.layers,
      palette: palette ?? this.palette,
      previewLayer: previewLayer ?? this.previewLayer,
      selectionPath: selectionPath ?? this.selectionPath,
    );
  }

  double canvasScale;
  HSLColor currentColor;
  PixelCanvasLayer get currentLayer => layers[currentLayerIndex];
  int currentLayerIndex;
  ToolType currentToolType;
  List<PixelCanvasLayer> layers;
  final PixelCanvasLayer previewLayer;
  var palette = new List<HSLColor>();
  Path selectionPath;
}

AppState stateReducer(AppState state, dynamic action) {
  if (action is AddCurrentColorToPaletteAction) {
    List<HSLColor> newPalette = List.from(state.palette);
    newPalette.add(state.currentColor);
    return state.copyWith(
    palette: newPalette,
    );
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
  else if (action is AddPixelAction) {
    state.previewLayer.setPixel(action.pos, state.currentColor.toColor());
    return state;
  }
  else if (action is ClearPreviewAction) {
    state.previewLayer.clearPixels();
    return state;
  }
  else if (action is DeselectAction) {
    state.selectionPath = null;
    return state;
  }
  else if (action is FillAreaAction) {
    state.currentLayer.fillArea(
        action.pos,
        state.currentColor.toColor()
    );
    return state;
  }
  else if (action is FinalizePixelsAction) {
    state.currentLayer.setPixelsFromMap(state.previewLayer.rawPixels);
    state.previewLayer.clearPixels();
    return state;
  }
  else if (action is SetCanvasScaleAction) {
    return state.copyWith(
      canvasScale: action.scale
    );
  }
  else if (action is SetCurrentColorAction) {
    return state.copyWith(
      currentColor: HSLColor.from(action.color),
    );
  }
  else if (action is SetCurrentLayerIndexAction) {
    if (action.currentLayerIndex < state.layers.length) {
      state.currentLayerIndex = action.currentLayerIndex;
    }
    return state;
  }
  else if (action is SetCurrentToolTypeAction) {
    return state.copyWith(
      currentToolType: action.toolType,
    );
  }
  else if(action is SetSelectionPath) {
    return state.copyWith(
      selectionPath: action.path
    );
  }
  else if (action is RemovePixelAction) {
    state.currentLayer.removePixel(action.pos);
    return state;
  }
  else {
    return state;
  }
}

