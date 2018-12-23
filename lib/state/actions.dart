import 'package:flutter/rendering.dart';

//import 'package:project_pickle/data_objects/hsl_color.dart';
import 'package:project_pickle/state/app_state.dart';
import 'package:project_pickle/tools/base_tool.dart';

class AddCurrentColorToPaletteAction {
  AddCurrentColorToPaletteAction();
}

class AddNewColorToPaletteAction {
  AddNewColorToPaletteAction(this.color);

  final Color color;
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

class EraseStartAction {
  EraseStartAction();
}

class EraseEndAction {
  EraseEndAction();
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

class SetActiveColorIndexAction {
  SetActiveColorIndexAction(this.index);
  final int index;
}

class SetCanvasScaleAction {
  SetCanvasScaleAction(this.scale);
  final double scale;
}

class SetPaletteColorAction {
  SetPaletteColorAction(
    this.index,
    this.color,
  );

  final Color color;
  final int index;
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

class RemoveColorAction{
  RemoveColorAction(this.index);

  final int index;
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

class ReorderColorAction {
  ReorderColorAction(
    this.oldIndex,
    this.newIndex,
  );

  final int oldIndex;
  final int newIndex;
}

class ReorderLayerAction {
  ReorderLayerAction(
    this.oldIndex,
    this.newIndex,
  );

  final int oldIndex;
  final int newIndex;
}

class UndoAction {
  UndoAction();
}

class SaveCanvasStateAction {
  SaveCanvasStateAction();
}