import 'package:flutter/material.dart';

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

class AppState {
  AppState({
    this.currentToolType = ToolType.pencil,
    this.currentColor,
    this.palette,
  });

  ToolType currentToolType;
  HSLColor currentColor;
  List<HSLColor> palette = new List<HSLColor>();
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
  else {
    return state;
  }
}