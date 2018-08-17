import 'package:flutter/rendering.dart';

import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/data_objects/tool_types.dart';
import 'package:project_pickle/widgets/canvas/pixel_canvas_layer.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';

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
  AddNewLayerAction(this.index);
  final int index;
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

class SaveOverlayToLayerAction {
  SaveOverlayToLayerAction(this.overlay);
  PixelCanvasLayer overlay;
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

class SetLeftDrawerSizeModeAction {
  SetLeftDrawerSizeModeAction(this.sizeMode);
  final DrawerSizeMode sizeMode;
}

class SetSelectionPathAction {
  SetSelectionPathAction(this.path);
  final Path path;
}

class SetRightDrawerSizeModeAction {
  SetRightDrawerSizeModeAction(this.sizeMode);
  final DrawerSizeMode sizeMode;
}

class RemovePixelAction {
  RemovePixelAction(this.pos);
  final Offset pos;
}

class RemoveLayerAction {
  RemoveLayerAction(this.index);
  final int index;
}
