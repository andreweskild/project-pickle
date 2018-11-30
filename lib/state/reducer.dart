import 'package:flutter/painting.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/canvas/pixel_layer.dart';

AppState stateReducer(AppState state, dynamic action) {

  if (action is AddCurrentColorToPaletteAction) {
    List<HSLColor> newPalette = List.from(state.palette);
    if (!newPalette.contains(state.activeColor)) {
      newPalette.add(state.activeColor);
    }
    return state.copyWith(
      palette: newPalette,
    );
  }
  else if (action is AddNewLayerAction) {
    int nameCount = state.layers.length + 1;
    int newIndex;
    if(state.layers.length == 0) {
      newIndex = 0;
    }
    else {
      newIndex = state.layers.indexOfActiveLayer + 1;
    }
    state.layers.insert(
        newIndex,
        PixelLayer(
          name: 'Layer $nameCount',
          height: 32,
          width: 32,
        )
    );
    state.layers.indexOfActiveLayer = newIndex;
    state.canvasDirty = true;
    return state;
  }
  else if (action is ClearPixelBufferAction) {
    state.drawingBuffer.clearBuffer();
    return state;
  }
  else if (action is DeselectAction) {
    state.selectionPath = null;
    return state;
  }
  else if (action is FillAreaAction) {
    state.currentLayer.fillArea(
        action.pos,
        state.activeColor.toColor(),
        state.selectionPath
    );
    return state.copyWith(
      canvasDirty: true,
    );
  }
  else if (action is FinalizePixelBufferAction) {
    state.drawingBuffer.toPixelList().forEach(
      (pixel) {
        state.currentLayer.setPixel(
          pixel,
          state.activeColor.toColor()
        );
      }
    );
    return state;
  }
  else if (action is ToggleLayerHiddenAction) {
    state.layers[action.index].toggleHidden();
    state.canvasDirty = true;
    return state;
  }
  else if (action is SetActiveColorTypeAction) {
    return state.copyWith(
      activeColorType: action.colorType,
      canvasDirty: true,
    );
  }
  else if (action is SetActiveColorIndexAction) {
    return state.copyWith(
      activeColorIndex: action.index,
      canvasDirty: true,
    );
  }
  else if (action is SetCanvasScaleAction) {
    return state.copyWith(
        canvasScale: action.scale
    );
  }
  else if (action is SetPaletteColorAction) {
    state.palette[action.index] = action.color;
    state.canvasDirty = true;
    return state;
  }
  else if (action is SetPrimaryColorAction) {
    return state.copyWith(
      primaryColor: HSLColor.fromAHSL(
        1.0,
        action.color.hue,
        action.color.saturation,
        action.color.lightness,
      ),
      canvasDirty: true,
    );
  }
  else if (action is SetSecondaryColorAction) {
    return state.copyWith(
      secondaryColor: HSLColor.fromAHSL(
        1.0,
        action.color.hue,
        action.color.saturation,
        action.color.lightness,
      ),
      canvasDirty: true,
    );
  }
  else if (action is SetCurrentLayerIndexAction) {
    if (action.currentLayerIndex < state.layers.length) {
      state.layers.indexOfActiveLayer = action.currentLayerIndex;
      state.canvasDirty = true;
    }
    return state;
  }
  else if (action is SetCurrentToolAction) {
    return state.copyWith(
      currentTool: action.tool,
      canvasDirty: true,
    );
  }
  else if(action is SetSelectionPathAction) {
    return state.copyWith(
        selectionPath: action.path
    );
  }
  else if (action is SetShapeFilledAction) {
    return state.copyWith(
      shapeFilled: action.filled,
      canvasDirty: true,
    );
  }
  else if(action is SetToolOpacityAction) {
    return state.copyWith(
      toolOpacity: action.opacity,
    );
  }
  else if (action is SetToolShapeAction) {
    return state.copyWith(
      toolShape: action.shape,
      canvasDirty: true,
    );
  }
  else if (action is SetToolSizeAction) {
    return state.copyWith(
      toolSize: action.size,
    );
  }
  else if (action is EraseStartAction) {
    return state.copyWith(
      eraserRemoveCounter: 0,
    );
  }
  else if (action is RemovePixelAction) {
    if (state.currentLayer.removePixel(action.pos)) {
      return state.copyWith(
        eraserRemoveCounter: state.eraserRemoveCounter + 1,
      );
    }
    return state;
  }
  else if (action is EraseEndAction) {
    if (state.eraserRemoveCounter == 0) {
      state.canvasHistory.removeLast();
    }
    return state.copyWith(
      eraserRemoveCounter: 0,
    );
  }
  else if (action is RemoveLayerAction) {
    state.layers.removeAt(action.index);
    if(state.layers.length == 0) {
      state.layers.indexOfActiveLayer = -1;
    }
    else if(action.index <= state.layers.indexOfActiveLayer &&
        state.layers.indexOfActiveLayer != 0) {
      state.layers.indexOfActiveLayer = state.layers.indexOfActiveLayer - 1;
    }
    state.canvasDirty = true;
    return state;
  }
  else {
    return state;
  }
}