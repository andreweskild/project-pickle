import 'package:flutter/rendering.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/data_objects/tool_types.dart';

class AddCurrentColorToPaletteAction {
  AddCurrentColorToPaletteAction();
}

class AddPixelAction {
  AddPixelAction(
      this.pos,
      );

  final Offset pos;
}

class AddNewLayerAction {
  AddNewLayerAction(this.name);
  final String name;
}

class ClearPreviewAction {
  ClearPreviewAction();
}

class DeselectAction {
  DeselectAction();
}

class FillAreaAction {
  FillAreaAction(this.pos);
  final Offset pos;
}

class FinalizePixelsAction {
  FinalizePixelsAction();
}

class SetCanvasScaleAction {
  SetCanvasScaleAction(this.scale);
  final double scale;
}

class SetCurrentColorAction {
  SetCurrentColorAction(this.color);
  final HSLColor color;
}

class SetCurrentLayerIndexAction {
  SetCurrentLayerIndexAction(
      this.currentLayerIndex,
      );
  final int currentLayerIndex;
}

class SetCurrentToolTypeAction {
  SetCurrentToolTypeAction(this.toolType);
  final ToolType toolType;
}

class SetSelectionPath {
  SetSelectionPath(this.path);
  final Path path;
}

class RemovePixelAction {
  RemovePixelAction(
      this. pos,
      );
  final Offset pos;
}
