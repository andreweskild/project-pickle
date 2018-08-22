import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/state/actions.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/color_picker_tool.dart';
import 'package:project_pickle/tools/eraser_tool.dart';
import 'package:project_pickle/tools/fill_tool.dart';
import 'package:project_pickle/tools/line_tool.dart';
import 'package:project_pickle/tools/pixel_tool.dart';
import 'package:project_pickle/tools/shape_tool.dart';
import 'package:project_pickle/tools/marquee_selector_tool.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';
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
  else if (action is ToggleLayerHiddenAction) {
    state.layers[action.index].toggleHidden();
    return state;
  }
  else if (action is SaveOverlayToLayerAction) {
    state.currentLayer.setPixelsFromMap(action.overlay.rawPixels);
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
    print(action.currentLayerIndex.toString());
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
  else if(action is SetSelectionPathAction) {
    return state.copyWith(
        selectionPath: action.path
    );
  }
  else if(action is SetRightDrawerSizeModeAction) {
    return state.copyWith(
      rightDrawerSizeMode: action.sizeMode,
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