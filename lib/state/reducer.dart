import 'package:flutter/painting.dart';
import 'package:project_pickle/canvas/pixel_buffer.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';

AppState stateReducer(AppState state, dynamic action) {

  if (action is AddCurrentColorToPaletteAction) {
    List<HSLColor> newPalette = List.from(state.palette);
    if (!newPalette.contains(state.currentColor)) {
      newPalette.add(state.currentColor);
    }
    return state.copyWith(
      palette: newPalette,
    );
  }
  else if (action is AddNewLayerAction) {
    int nameCount = state.layerNamingCounter + 1;
    int newIndex;
    if(state.currentLayerIndex == -1) {
      newIndex = 0;
    }
    else {
      newIndex = state.currentLayerIndex + 1;
    }
    state.layers.insert(
        newIndex,
        new PixelCanvasLayer(
          name: 'Layer $nameCount',
          height: 32,
          width: 32,
        )
    );
    state.layerNamingCounter = nameCount;
    state.currentLayerIndex = newIndex;
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
        state.currentColor.toColor(),
        state.selectionPath
    );
    return state;
  }
  else if (action is FinalizePixelBufferAction) {
    state.drawingBuffer.toPixelList().forEach(
      (pixel) {
        state.currentLayer.setPixel(pixel, state.currentColor.toColor());
      }
    );
    return state;
  }
  else if (action is ToggleLayerHiddenAction) {
    state.layers[action.index].toggleHidden();
    return state;
  }
  else if (action is SetActiveColorTypeAction) {
    return state.copyWith(
        activeColorType: action.colorType,
    );
  }
  else if (action is SetCanvasScaleAction) {
    return state.copyWith(
        canvasScale: action.scale
    );
  }
  else if (action is SetPrimaryColorAction) {
    return state.copyWith(
      primaryColor: HSLColor.fromAHSL(
        1.0,
        action.color.hue,
        action.color.saturation,
        action.color.lightness,
      ),
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
    );
  }
  else if (action is SetCurrentLayerIndexAction) {
    if (action.currentLayerIndex < state.layers.length) {
      state.currentLayerIndex = action.currentLayerIndex;
    }
    return state;
  }
  else if (action is SetCurrentToolAction) {
    state.currentTool = action.tool;
    return state;
  }
  else if(action is SetLeftDrawerSizeModeAction) {
    return state.copyWith(
      leftDrawerSizeMode: action.sizeMode,
    );
  }
  else if(action is SetRightDrawerSizeModeAction) {
    return state.copyWith(
      rightDrawerSizeMode: action.sizeMode,
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
    );
  }
  else if(action is SetToolOpacityAction) {
    return state.copyWith(
      toolOpacity: action.opacity
    );
  }
  else if (action is SetToolShapeAction) {
    return state.copyWith(
      toolShape: action.shape,
    );
  }
  else if (action is SetToolSizeAction) {
    return state.copyWith(
      toolSize: action.size,
    );
  }
  else if (action is RemovePixelAction) {
    state.currentLayer.removePixel(action.pos);
    return state;
  }
  else if (action is RemoveLayerAction) {
    state.layers.removeAt(action.index);
    if(state.layers.length == 0) {
      state.currentLayerIndex = -1;
    }
    else if(action.index <= state.currentLayerIndex &&
        state.currentLayerIndex != 0) {
      state.currentLayerIndex = state.currentLayerIndex - 1;
    }
    return state;
  }
  else {
    return state;
  }
}