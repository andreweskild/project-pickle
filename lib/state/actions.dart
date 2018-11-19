import 'package:flutter/rendering.dart';

//import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_tool.dart';
import 'package:project_pickle/widgets/layout/responsive_drawer.dart';

class AddCurrentColorToPaletteAction {
  AddCurrentColorToPaletteAction();
}

class AddNewLayerAction {
  AddNewLayerAction();
}

class ClearPixelBufferAction {
  ClearPixelBufferAction();
}

class DeselectAction {
  DeselectAction();
}

class FillAreaAction {
  FillAreaAction(this.pos);
  final Offset pos;
}

class FinalizePixelBufferAction {
  FinalizePixelBufferAction();
}


class ToggleLayerHiddenAction {
  ToggleLayerHiddenAction(this.index);
  final int index;
}

class SetActiveColorTypeAction {
  SetActiveColorTypeAction(this.colorType);
  final ColorType colorType;
}

class SetCanvasScaleAction {
  SetCanvasScaleAction(this.scale);
  final double scale;
}


class SetCurrentLayerIndexAction {
  SetCurrentLayerIndexAction(
      this.currentLayerIndex,
      );
  final int currentLayerIndex;
}

class SetCurrentToolAction {
  SetCurrentToolAction(this.tool);
  final BaseTool tool;
}

class SetLeftDrawerSizeModeAction {
  SetLeftDrawerSizeModeAction(this.sizeMode);
  final DrawerSizeMode sizeMode;
}


class SetPrimaryColorAction {
  SetPrimaryColorAction(this.color);
  final HSLColor color;
}

class SetSecondaryColorAction {
  SetSecondaryColorAction(this.color);
  final HSLColor color;
}

class SetRightDrawerSizeModeAction {
  SetRightDrawerSizeModeAction(this.sizeMode);
  final DrawerSizeMode sizeMode;
}

class SetSelectionPathAction {
  SetSelectionPathAction(this.path);
  final Path path;
}

class SetToolOpacityAction {
  SetToolOpacityAction(this.opacity);
  final double opacity;
}

class SetToolShapeAction {
  SetToolShapeAction(this.shape);
  final ShapeMode shape;
}

class SetToolSizeAction {
  SetToolSizeAction(this.size);
  final double size;
}

class SetShapeFilledAction {
  SetShapeFilledAction(this.filled);
  final bool filled;
}

class RemovePixelAction {
  RemovePixelAction(this.pos);
  final Offset pos;
}

class RemoveLayerAction {
  RemoveLayerAction(this.index);
  final int index;
}

class RedoAction {
  RedoAction();
}

class UndoAction {
  UndoAction();
}